module Admin
  # The signed-in user's own account: email and password updates, verified by
  # the current password. Deliberately NO destroy — accounts are never deleted
  # from the UI (an orphaned admin or dangling session must not be possible).
  class SettingsController < BaseController
    def show
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update_with_password(settings_params)
        # Password (or email) changes invalidate the Devise session — re-sign
        # the user in so saving settings never logs them out.
        bypass_sign_in(@user)
        redirect_to admin_settings_path, notice: "Account updated."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def settings_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end
  end
end
