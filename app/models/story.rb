# A consented patient story (stories page). Dynamic counterpart of the old
# fixed story_1..3 section keys.
class Story < ApplicationRecord
  has_one_attached :photo

  validates :quote_en, :quote_ar, presence: true

  default_scope { order(:position) }

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
