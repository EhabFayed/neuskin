module Admin
  class BaseController < ApplicationController
    layout "admin"

    # Admin chrome is English-only; never run the public locale switch here.
    skip_around_action :switch_locale, raise: false

    before_action :authenticate_user!
    before_action :set_nav_counts

    # Which sidebar item to highlight. Subclasses override; defaults to the
    # controller name so Pages/Sections light up "Pages", dashboard lights
    # up "Overview".
    helper_method :admin_nav
    def admin_nav
      case controller_name
      when "dashboard" then :overview
      when "pages", "sections" then :pages
      else controller_name.to_sym
      end
    end

    private

    # Sidebar counts — editable pages in the registry, journal posts in the DB.
    def set_nav_counts
      @nav_pages_count = SitePages::LIST.size
      @nav_blogs_count = Blog.count
    end

    # Guard for admin-only areas (e.g. user management). Editors are bounced.
    def require_admin!
      return if current_user&.admin?

      redirect_to admin_root_path, alert: "Admins only."
    end
  end
end
