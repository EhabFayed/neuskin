class ApplicationController < ActionController::Base
  around_action :switch_locale

  # Reads :locale from the path (e.g. /en, /ar). Falls back to the default
  # (Arabic). Keeps the chosen locale in generated URLs.
  def switch_locale(&action)
    locale = params[:locale]
    locale = I18n.default_locale unless I18n.available_locales.map(&:to_s).include?(locale)
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
