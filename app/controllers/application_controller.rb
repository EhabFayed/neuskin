class ApplicationController < ActionController::Base
  around_action :switch_locale

  # Devise (sign-in / password) screens use a dedicated, chrome-free auth
  # layout styled to the Studio design — not the public site layout — and are
  # English-only like the admin.
  layout :layout_by_resource
  skip_around_action :switch_locale, if: :devise_controller?

  def layout_by_resource
    devise_controller? ? "auth" : "application"
  end

  # After signing in, land in the Studio dashboard, not the public homepage.
  def after_sign_in_path_for(_resource)
    admin_root_path
  end

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
