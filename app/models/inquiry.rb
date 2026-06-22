class Inquiry < ApplicationRecord
  extend Enumerize

  # "What brings you here" — the six personas plus general entry reasons.
  enumerize :persona, in: %i[bride tired hair maintain fresh unsure], scope: true

  validates :name, presence: true
  validates :mobile, presence: true,
                     format: { with: /\A\+9665\d{8}\z/, message: :invalid_ksa_mobile }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  before_validation :normalize_mobile

  private

  # Accept "05XXXXXXXX", "5XXXXXXXX", "9665XXXXXXXX", "+9665XXXXXXXX" → +9665XXXXXXXX.
  def normalize_mobile
    return if mobile.blank?

    digits = mobile.gsub(/\D/, "")
    digits = digits.sub(/\A966/, "")     # strip country code if present
    digits = digits.sub(/\A0/, "")        # strip leading local 0
    self.mobile = "+966#{digits}"
  end
end
