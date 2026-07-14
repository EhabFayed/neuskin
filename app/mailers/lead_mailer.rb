# Lead emails — every form submission sends TWO mails: an internal
# notification to the clinic info address, and a bilingual confirmation to the
# visitor ("we received your inquiry and will call you") when they left an
# email. Confirmations render in the visitor's preferred locale.
class LeadMailer < ApplicationMailer
  def inquiry_notification(inquiry)
    @inquiry = inquiry
    mail to: Clinic::INFO_EMAIL,
         subject: "New inquiry — #{inquiry.name} (#{inquiry.source_codeword.presence || 'general'})"
  end

  def inquiry_confirmation(inquiry)
    @inquiry = inquiry
    with_lead_locale(inquiry) do
      mail to: inquiry.email, subject: I18n.t("mailer.inquiry_confirmation.subject")
    end
  end

  def bridal_notification(lead)
    @lead = lead
    mail to: Clinic::INFO_EMAIL,
         subject: "New bridal lead — #{lead.email}"
  end

  def bridal_confirmation(lead)
    @lead = lead
    with_lead_locale(lead) do
      mail to: lead.email, subject: I18n.t("mailer.bridal_confirmation.subject")
    end
  end

  private

  def with_lead_locale(record, &block)
    locale = record.preferred_locale.presence_in(%w[ar en]) || I18n.default_locale
    I18n.with_locale(locale, &block)
  end
end
