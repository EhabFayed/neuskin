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
  %i[name promise duration meta who_for scope excludes].each do |attr|
    define_method(attr) do
      public_send("#{attr}_#{localized_suffix}")
    end
  end

  # Localized pick for a JSONB hash with _ar/_en keys, e.g. stage["title_ar"].
  def loc(hash, key)
    return if hash.blank?
    hash["#{key}_#{localized_suffix}"]
  end

  private

  def localized_suffix
    I18n.locale == :ar ? "ar" : "en"
  end
end
