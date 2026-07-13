require "rails_helper"

RSpec.describe "Lead forms — emails and dashboard", type: :request do
  include ActiveJob::TestHelper

  after { clear_enqueued_jobs; ActionMailer::Base.deliveries.clear }

  describe "inquiry form" do
    it "saves the lead and sends both emails (internal + Arabic confirmation)" do
      expect do
        perform_enqueued_jobs do
          post "/ar/inquire", params: { inquiry: {
            name: "نورة", mobile: "0512345678", email: "noura@example.com",
            persona: "bride", preferred_time: "evening"
          } }
        end
      end.to change(Inquiry, :count).by(1)

      mails = ActionMailer::Base.deliveries
      expect(mails.size).to eq(2)

      internal = mails.find { |m| m.to == [Clinic::INFO_EMAIL] }
      expect(internal.subject).to include("New inquiry — نورة")
      expect(internal.body.encoded).to include("+966512345678")

      confirmation = mails.find { |m| m.to == ["noura@example.com"] }
      expect(confirmation.subject).to eq("استلمنا استفسارك — عيادة نيو سكين")
      expect(confirmation.body.to_s).to include("سنتصل بك خلال ساعتين")
    end

    it "sends only the internal mail when the visitor left no email" do
      perform_enqueued_jobs do
        post "/inquire", params: { inquiry: { name: "Sara", mobile: "0512345678" } }
      end
      mails = ActionMailer::Base.deliveries
      expect(mails.size).to eq(1)
      expect(mails.first.to).to eq([Clinic::INFO_EMAIL])
    end

    it "sends the confirmation in English for English-locale leads" do
      perform_enqueued_jobs do
        post "/inquire", params: { inquiry: {
          name: "Sara", mobile: "0512345678", email: "sara@example.com"
        } }
      end
      confirmation = ActionMailer::Base.deliveries.find { |m| m.to == ["sara@example.com"] }
      expect(confirmation.subject).to eq("We received your inquiry — NeuSkin Clinic")
      expect(confirmation.body.to_s).to include("We will call you within two hours")
    end
  end

  describe "bridal checklist form" do
    it "saves the lead and sends both emails" do
      expect do
        perform_enqueued_jobs do
          post "/bridal-concierge/checklist", params: { bridal_lead: {
            email: "bride@example.com", wedding_date: 3.months.from_now.to_date
          } }
        end
      end.to change(BridalLead, :count).by(1)

      mails = ActionMailer::Base.deliveries
      expect(mails.size).to eq(2)
      expect(mails.map(&:to)).to contain_exactly([Clinic::INFO_EMAIL], ["bride@example.com"])
    end
  end

  describe "dashboard" do
    it "lists the leads under Recent leads" do
      Inquiry.create!(name: "Noura", mobile: "+966512345678", persona: "bride", source_codeword: "METHOD")
      BridalLead.create!(email: "bride@example.com")
      sign_in create(:user)
      get "/admin"
      expect(response.body).to include("Recent leads")
      expect(response.body).to include("Noura · bride")
      expect(response.body).to include("Inquiry · METHOD")
      expect(response.body).to include("bride@example.com")
      expect(response.body).to include("Bridal checklist")
    end
  end
end
