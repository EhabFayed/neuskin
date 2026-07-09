module Admin
  class DashboardController < BaseController
    def index
      @inquiries_count    = Inquiry.count
      @bridal_leads_count = BridalLead.count
      @protocols_count    = Protocol.count
      @sections_count     = Section.count
    end
  end
end
