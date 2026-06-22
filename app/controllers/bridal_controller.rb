class BridalController < ApplicationController
  def show
    @protocol = Protocol.find_by(slug: "brides-180")
    @lead = BridalLead.new
  end

  # Email-gated lead magnet: capture the email, then deliver the checklist.
  def checklist
    @lead = BridalLead.new(lead_params)
    @lead.preferred_locale ||= I18n.locale.to_s

    if @lead.save
      # STUB: the real "6-month bridal skin checklist" PDF and the nurture
      # sequence are not built yet. For now, confirm capture inline.
      redirect_to bridal_concierge_path(checklist: "sent"),
                  notice: t("bridal.checklist.success")
    else
      @protocol = Protocol.find_by(slug: "brides-180")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.require(:bridal_lead).permit(:email, :wedding_date)
  end
end
