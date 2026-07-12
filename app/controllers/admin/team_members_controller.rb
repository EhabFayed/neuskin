module Admin
  # Medical team CRUD — the dynamic counterpart of the old fixed-key
  # the_team/team_members section (top_brand leadership pattern).
  class TeamMembersController < BaseController
    before_action :set_member, only: [:edit, :update, :destroy]

    def index
      @members = TeamMember.with_attached_photo
    end

    def new
      @member = TeamMember.new(position: TeamMember.count + 1)
    end

    def create
      @member = TeamMember.new(member_params)
      if @member.save
        redirect_to admin_team_members_path, notice: "Member added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @member.update(member_params)
        @member.photo.purge if params[:team_member][:remove_photo] == "1"
        redirect_to admin_team_members_path, notice: "Member saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @member.destroy
      redirect_to admin_team_members_path, notice: "Member removed."
    end

    private

    def set_member
      @member = TeamMember.find(params[:id])
    end

    def member_params
      params.require(:team_member).permit(
        :name_ar, :name_en, :role_ar, :role_en, :cred_ar, :cred_en,
        :focus_ar, :focus_en, :bio_ar, :bio_en, :position, :photo
      )
    end
  end
end
