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

  # URL for the CURRENT page in the other locale — so the language toggle stays
  # on the same page (and keeps query params like ?persona=) instead of jumping
  # home. Arabic is the default, so it carries no /ar prefix.
  def switch_locale_url
    other = ar? ? :en : :ar
    # Merge the resolved route params (controller/action/:id/:slug) + the query
    # string, then override locale. Rebuilds the exact current page in the other
    # locale. Arabic is default, so it carries no /ar prefix.
    params = request.path_parameters.merge(request.query_parameters).symbolize_keys
    params[:locale] = (other == I18n.default_locale ? nil : other)
    url_for(params.merge(only_path: true))
  rescue ActionController::UrlGenerationError
    root_path(locale: (other == I18n.default_locale ? nil : other))
  end
end
