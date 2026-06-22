class Protocol < ApplicationRecord
  extend Enumerize

  # Personas the "I'm here because…" filter routes on (architecture §06).
  enumerize :persona, in: %i[bride tired hair maintain fresh unsure], scope: true

  validates :slug, presence: true, uniqueness: true
  validates :name_ar, :name_en, presence: true

  default_scope { order(:position) }

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
