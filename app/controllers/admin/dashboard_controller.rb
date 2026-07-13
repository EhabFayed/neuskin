module Admin
  class DashboardController < BaseController
    def index
      @inquiries_count    = Inquiry.count
      @bridal_leads_count = BridalLead.count
      @protocols_count    = Protocol.count
      @sections_count     = Section.count
      @blogs_count        = Blog.count
      @drafts_count       = Blog.where(is_published: false).count
      @team_count         = TeamMember.count
      @faqs_count         = Faq.count
      @stories_count      = Story.count
    end
  end
end
