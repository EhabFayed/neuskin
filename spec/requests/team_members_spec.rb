require "rails_helper"

RSpec.describe "Team members", type: :request do
  def make_member(attrs = {})
    TeamMember.create!({
      name_en: "Dr. Lina Haddad", name_ar: "د. لينا حدّاد",
      role_en: "Senior Aesthetic Physician", role_ar: "طبيبة تجميل أولى",
      focus_en: "Injectables & restraint", focus_ar: "الحقن وضبط النفس",
      bio_en: "Executes the plan with a light hand.", bio_ar: "تنفّذ الخطة بيدٍ خفيفة.",
      position: 2
    }.merge(attrs))
  end

  # The public page is hidden (Oct 2026, client request) — its URL 301s home
  # like any unknown path, and the footer no longer links to it. The admin
  # CRUD below still works so the members are ready when the page returns.
  describe "public page (hidden)" do
    it "sends /the-team home in both languages" do
      make_member
      get "/the-team"
      expect(response).to redirect_to("/")
      get "/ar/the-team"
      expect(response).to redirect_to("/ar")
    end

    it "is not linked from the footer or listed in the sitemap" do
      get "/"
      expect(response.body).not_to include("/the-team")
      get "/sitemap.xml"
      expect(response.body).not_to include("/the-team")
    end
  end

  describe "admin" do
    before { sign_in create(:user) }

    it "creates a member" do
      post "/admin/team_members", params: { team_member: {
        name_en: "Dr. New", name_ar: "د. جديدة", role_en: "Physician", role_ar: "طبيبة", position: 5
      } }
      expect(TeamMember.find_by(name_en: "Dr. New")).to be_present
      expect(response).to redirect_to("/admin/team_members")
    end

    it "removes the photo when the checkbox is ticked" do
      member = make_member
      member.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/pixel.png")),
                          filename: "portrait.png")
      patch "/admin/team_members/#{member.id}",
            params: { team_member: { name_en: member.name_en, remove_photo: "1" } }
      expect(member.reload.photo).not_to be_attached
    end

    it "deletes a member" do
      member = make_member
      delete "/admin/team_members/#{member.id}"
      expect(TeamMember.exists?(member.id)).to be(false)
    end
  end
end
