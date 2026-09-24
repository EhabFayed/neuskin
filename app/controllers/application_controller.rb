class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :drop_default_locale_prefix

  # Devise (sign-in / password) screens use a dedicated, chrome-free auth
  # layout styled to the Studio design — not the public site layout — and are
  # English-only like the admin.
  layout :layout_by_resource
  skip_around_action :switch_locale, if: :devise_controller?

  # Records that no longer exist (/journal/old-slug, /treatments/removed) and
  # stale slugs also go home with a 301 rather than a bare 404 — same policy
  # as the routing catch-all in routes.rb. The admin keeps real 404s so an
  # editor sees what went wrong.
  rescue_from ActiveRecord::RecordNotFound do |error|
    raise error if request.path.start_with?("/admin")

    redirect_to root_path, status: :moved_permanently
  end

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

  # English is the default locale and carries no prefix, so /en/... was the
  # same page as /... under a second URL. One indexable URL per language:
  # GET/HEAD on /en 301 to the bare path (query string kept). /ar is untouched.
  def drop_default_locale_prefix
    return unless params[:locale] == I18n.default_locale.to_s
    return unless request.get? || request.head?

    path = request.path.sub(%r{\A/#{I18n.default_locale}(?=/|\z)}, "").presence || "/"
    path = "#{path}?#{request.query_string}" if request.query_string.present?
    redirect_to path, status: :moved_permanently
  end

  # For pages whose route params differ by language (a journal article's
  # slug_en / slug_ar), name the params that build the page in each locale.
  # The layout's hreflang alternates and the header language switch use them
  # (ApplicationHelper#localized_route_params).
  def localize_route_params(**per_locale)
    @localized_route_params = per_locale
  end
end
