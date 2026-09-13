# Catch-all for paths that match no route (see the bottom of routes.rb).
# Instead of a 404 page the visitor lands on the homepage in their locale
# with a permanent redirect, so search engines drop the dead URL.
class ErrorsController < ApplicationController
  skip_around_action :switch_locale, raise: false

  def redirect_home
    locale = request.path.split("/")[1]
    locale = nil unless I18n.available_locales.map(&:to_s).include?(locale)
    redirect_to root_path(locale: (locale == I18n.default_locale.to_s ? nil : locale)),
                status: :moved_permanently, allow_other_host: false
  end
end
