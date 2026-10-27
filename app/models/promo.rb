# One digital gift card (/promo, /promo/:code): the gift or treatment name
# (label), the percentage off, the promo code and the headline + line shown
# above it on the card. Fully managed in the dashboard (Admin::PromosController).
#
# Uses: a "use" is a tap on "Reserve my private glow" (PromosController#claim).
# max_uses nil means unlimited; once uses_count reaches max_uses the gift
# stops showing until an editor raises the limit or resets the count.
class Promo < ApplicationRecord
  CODE_FORMAT = /\A[A-Z0-9][A-Z0-9_-]*\z/

  validates :label_en, :title_en, presence: true
  validates :percent, presence: true,
                      numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
  validates :code, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: CODE_FORMAT, message: "may only use letters, numbers, - and _" }
  validates :max_uses, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :uses_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  default_scope { order(:position, :id) }

  # What the public page can show: active and not yet fully used.
  scope :available, -> { where(active: true).where("max_uses IS NULL OR uses_count < max_uses") }

  before_validation :normalize_code

  # Locale-aware readers: promo.title returns title_ar or title_en for the
  # current locale, falling back to English when Arabic is blank.
  %i[label title description].each do |attr|
    define_method(attr) do
      ar = public_send("#{attr}_ar")
      en = public_send("#{attr}_en")
      I18n.locale == :ar && ar.present? ? ar : en
    end
  end

  def unlimited? = max_uses.nil?

  def exhausted? = !unlimited? && uses_count >= max_uses

  def remaining_uses
    unlimited? ? nil : [ max_uses - uses_count, 0 ].max
  end

  # Counts one use, atomically and only while active and under the limit.
  # Returns true when the use was recorded, false when the promo is spent.
  def claim!
    claimed = Promo.unscoped
                   .where(id: id, active: true)
                   .where("max_uses IS NULL OR uses_count < max_uses")
                   .update_all([ "uses_count = uses_count + 1, updated_at = ?", Time.current ])
    reload
    claimed == 1
  end

  # The WhatsApp deep link with the concept's message:
  # "Hello NeuSkin, I'd like to reserve my private glow. Code: GLOW30".
  def whatsapp_url
    message = I18n.t("promo.whatsapp_message", code: code)
    "https://wa.me/#{Clinic::WHATSAPP_NUMBER}?text=#{ERB::Util.url_encode(message)}"
  end

  private

  def normalize_code
    self.code = code.to_s.strip.upcase.gsub(/\s+/, "")
  end
end
