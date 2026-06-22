module ApplicationHelper
  # View-side wrapper around Clinic.whatsapp_url. Pulls the prefill text from
  # the current locale.
  def whatsapp_url(codeword: nil)
    Clinic.whatsapp_url(text: t("whatsapp.prefill"), codeword: codeword)
  end
end
