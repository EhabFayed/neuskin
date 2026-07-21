require "rails_helper"

# The site must degrade gracefully, never crash: every public page renders
# with a COMPLETELY empty database (no sections, records or images), and with
# records that carry only their required fields.
RSpec.describe "Page resilience", type: :request do
  PUBLIC_PATHS = %w[
    / /the-clinic /journal /stories /faq /privacy /medical-disclaimer /terms
    /the-team /neuskin-method /technologies /treatments /treatments/skin
    /treatments/hair /treatments/body /treatments/injectables /treatments/devices
    /private-care /protocols /inquire /bridal-concierge
  ].freeze

  describe "with an empty database" do
    it "renders every public page in both locales" do
      PUBLIC_PATHS.each do |path|
        get path
        expect(response).to have_http_status(:ok), "EMPTY DB: #{path} -> #{response.status}"
        get "/ar#{path == '/' ? '' : path}"
        expect(response).to have_http_status(:ok), "EMPTY DB: /ar#{path} -> #{response.status}"
      end
    end
  end

  describe "with minimal records (only required fields present)" do
    before do
      Protocol.create!(slug: "bare", name_en: "Bare", name_ar: "الأدنى")
      Blog.create!(title_en: "Bare note", title_ar: "تدوينة", is_published: true)
      TeamMember.create!(name_en: "Dr. Bare", name_ar: "د. الأدنى")
      Story.create!(quote_en: "Bare quote.", quote_ar: "اقتباس.")
      Faq.create!(question_en: "Bare?", question_ar: "سؤال؟",
                  answer_en: "Yes.", answer_ar: "نعم.")
    end

    it "renders the pages that show those records, plus their detail pages" do
      ["/", "/protocols", "/protocols/bare", "/journal", "/journal/bare-note",
       "/the-team", "/stories", "/faq"].each do |path|
        get path
        expect(response).to have_http_status(:ok), "MINIMAL: #{path} -> #{response.status}"
        get "/ar#{path}"
        expect(response).to have_http_status(:ok), "MINIMAL: /ar#{path} -> #{response.status}"
      end
    end
  end
end
