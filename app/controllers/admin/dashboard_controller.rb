module Admin
  class DashboardController < BaseController
    def index
      @inquiries_count    = Inquiry.count
      @inquiries_week     = Inquiry.where(created_at: 7.days.ago..).count
      @bridal_leads_count = BridalLead.count
      @bridal_week        = BridalLead.where(created_at: 7.days.ago..).count
      @protocols_count    = Protocol.count
      @sections_count     = Section.count
      @blogs_count        = Blog.count
      @drafts_count       = Blog.where(is_published: false).count
      @team_count         = TeamMember.count
      @faqs_count         = Faq.count
      @stories_count      = Story.count
      # Latest leads across both forms, newest first.
      @recent_leads = (Inquiry.order(created_at: :desc).limit(8).to_a +
                       BridalLead.order(created_at: :desc).limit(8).to_a)
                      .sort_by(&:created_at).reverse.first(8)
    end
  end
end
