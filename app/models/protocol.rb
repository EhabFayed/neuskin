class Protocol < ApplicationRecord
  extend Enumerize

  # Card / stage / hero photo — dashboard-uploaded; the launch static asset
  # (see ContentHelper#protocol_image_url) is the fallback.
  has_one_attached :image

  # Personas the "I'm here because…" filter routes on (architecture §06).
  enumerize :persona, in: %i[bride tired hair maintain fresh unsure], scope: true

  validates :slug, presence: true, uniqueness: true
  validates :name_ar, :name_en, presence: true

  default_scope { order(:position) }

  # Admin can leave the slug blank on create — derived from the English name.
  before_validation { self.slug = name_en.to_s.parameterize if slug.blank? }

  def to_param = slug

  # Locale-aware readers: protocol.name returns name_ar or name_en for the
  # current I18n locale. Covers every paired _ar/_en column.
  %i[name promise duration meta who_for scope excludes why_title meta_title meta_description].each do |attr|
    define_method(attr) do
      public_send("#{attr}_#{localized_suffix}")
    end
  end

  # "Who it's for" signs — one per line in signs_ar / signs_en (Admin →
  # Protocols). Arabic falls back to the English lines, and both fall back to
  # the locale's standard three, so a protocol with none still reads well.
  def signs
    own = split_lines(public_send("signs_#{localized_suffix}"))
    own = split_lines(signs_en) if own.empty?
    own.presence || I18n.t("protocol_page.signs")
  end

  # Hero rows under the title (label/value pairs) for the current locale;
  # blank ones dropped. Empty → the view shows the original three.
  def specs_for_locale
    Array(specs).filter_map do |row|
      label, value = loc(row, "label").presence, loc(row, "value").presence
      [ label, value ] if label || value
    end
  end

  # "Why choose …" points for the current locale (text_ar / text_en), blank
  # ones dropped — the block only renders when there is something to say.
  def why_points_for_locale
    Array(why_points).filter_map { |p| loc(p, "text").presence }
  end

  # Localized pick for a JSONB hash with _ar/_en keys, e.g. stage["title_ar"].
  def loc(hash, key)
    return if hash.blank?
    hash["#{key}_#{localized_suffix}"]
  end

  private

  def split_lines(text)
    text.to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
  end

  def localized_suffix
    I18n.locale == :ar ? "ar" : "en"
  end
end
