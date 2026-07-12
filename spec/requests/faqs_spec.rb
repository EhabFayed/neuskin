require "rails_helper"

RSpec.describe "FAQs", type: :request do
  def make_faq(attrs = {})
    Faq.create!({
      question_en: "Do you publish a price list?", question_ar: "هل تنشرون قائمة أسعار؟",
      answer_en: "No. Care is arranged by consultation.", answer_ar: "لا. الرعاية تُرتَّب عبر الاستشارة.",
      category: "before_you_come_in", position: 1
    }.merge(attrs))
  end

  describe "public page" do
    it "renders questions grouped by category" do
      make_faq
      make_faq(question_en: "Why a twelve-month plan?", question_ar: "لماذا خطة سنة؟",
               category: "how_care_works")
      get "/faq"
      expect(response.body).to include("Do you publish a price list?")
      expect(response.body).to include("Before you come in")
      expect(response.body).to include("How care works")
    end

    it "renders Arabic under /ar" do
      make_faq
      get "/ar/faq"
      expect(response.body).to include("هل تنشرون قائمة أسعار؟")
      expect(response.body).to include("قبل زيارتك")
    end

    it "omits empty groups" do
      make_faq(category: "privacy")
      get "/faq"
      expect(response.body).not_to include("How care works")
    end
  end

  describe "admin" do
    before { sign_in create(:user) }

    it "creates a question" do
      post "/admin/faqs", params: { faq: {
        question_en: "New?", question_ar: "جديد؟",
        answer_en: "Yes.", answer_ar: "نعم.", category: "privacy", position: 4
      } }
      expect(Faq.find_by(question_en: "New?")).to be_present
      expect(response).to redirect_to("/admin/faqs")
    end

    it "deletes a question" do
      faq = make_faq
      delete "/admin/faqs/#{faq.id}"
      expect(Faq.exists?(faq.id)).to be(false)
    end
  end

  describe "dashboard overview" do
    it "shows real counts and CRUD shortcuts" do
      sign_in create(:user)
      make_faq
      get "/admin"
      expect(response.body).to include("Questions")
      expect(response.body).to include("/admin/faqs")
      expect(response.body).to include("/admin/team_members")
      expect(response.body).to include("/admin/blogs/new")
    end
  end
end
