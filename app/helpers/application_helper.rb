module ApplicationHelper
  # View-side wrapper around Clinic.whatsapp_url. Pulls the prefill text from
  # the current locale.
  def whatsapp_url(codeword: nil)
    Clinic.whatsapp_url(text: t("whatsapp.prefill"), codeword: codeword)
  end

  # Returns the string for the active locale. The whole site renders one
  # language at a time (Arabic when locale == :ar, English otherwise).
  def loc(ar:, en:)
    I18n.locale == :ar ? ar : en
  end

  # True when the active locale is Arabic (RTL).
  def ar?
    I18n.locale == :ar
  end

  # Wraps text in a <span> carrying the correct dir for the active locale —
  # used inside mixed runs. Returns an html_safe span.
  def loc_dir
    ar? ? "rtl" : "ltr"
  end
end
