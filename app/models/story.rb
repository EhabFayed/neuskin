# A consented patient story (stories page). Dynamic counterpart of the old
# fixed story_1..3 section keys.
class Story < ApplicationRecord
  has_one_attached :photo

  validates :quote_en, :quote_ar, presence: true

  default_scope { order(:position) }

  # /stories only shows visible stories; the dashboard lists them all.
  scope :visible, -> { where(hidden: false) }
  # Ticked "Highlight on home" in the dashboard — the home reviews band shows
  # visible + highlighted stories only (client audit, Oct 2026).
  scope :highlighted, -> { where(highlighted: true) }

  # Locale-aware readers, mirroring Protocol.
  %i[intro quote protocol_line close byline].each do |attr|
    define_method(attr) do
      public_send("#{attr}_#{localized_suffix}")
    end
  end

  private

  def localized_suffix
    I18n.locale == :ar ? "ar" : "en"
  end
end
