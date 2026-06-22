class BridalLead < ApplicationRecord
  # Soft lead from the §10 bridal checklist download. Feeds the Reset / nurture
  # sequence later.
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
