module Admin
  class BaseController < ApplicationController
    layout "admin"

    # Admin chrome is English-only; never run the public locale switch here.
    skip_around_action :switch_locale, raise: false

    before_action :authenticate_user!

    private

    # Guard for admin-only areas (e.g. user management). Editors are bounced.
    def require_admin!
      return if current_user&.admin?

      redirect_to admin_root_path, alert: "Admins only."
    end
  end
end
