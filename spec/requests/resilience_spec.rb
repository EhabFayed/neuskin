require "rails_helper"

# The site must degrade gracefully, never crash: every public page renders
# with a COMPLETELY empty database (no sections, records or images), and with
# records that carry only their required fields.
RSpec.describe "Page resilience", type: :request do
  # Outcome pages are Treatment records now (dashboard-managed), so on an
  # empty database /treatments/<slug> has nothing to render and — like every
  # unknown URL — 301s home (see the "minimal records" block for the real page).
  PUBLIC_PATHS = %w[
    / /the-clinic /journal /stories /faq /privacy /medical-disclaimer /terms
    /the-team /neuskin-method /technologies /treatments
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
      Treatment.create!(slug: "bare-skin", title_en: "Skin", headline_en: "Bare skin")
      Device.create!(name: "BARE-1")
    end

    it "renders the pages that show those records, plus their detail pages" do
      # A journal article has a slug per language: its Arabic page lives under
      # the Arabic slug (the English slug 301s there — see JournalController).
      arabic_slug = ERB::Util.url_encode(Blog.find_by!(slug_en: "bare-note").slug_ar)
      [ "/", "/protocols", "/protocols/bare", "/journal", "/journal/bare-note",
       "/the-team", "/stories", "/faq", "/treatments", "/treatments/bare-skin",
       "/technologies" ].each do |path|
        get path
        expect(response).to have_http_status(:ok), "MINIMAL: #{path} -> #{response.status}"
        ar_path = path == "/journal/bare-note" ? "/journal/#{arabic_slug}" : path
        get "/ar#{ar_path}"
        expect(response).to have_http_status(:ok), "MINIMAL: /ar#{ar_path} -> #{response.status}"
      end
    end
  end
end
