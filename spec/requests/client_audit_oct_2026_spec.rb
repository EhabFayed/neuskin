require "rails_helper"

# Client audit (Oct 2026, "اوديت تعديلات موقع نيو سكين"): structural changes to
# the home and clinic pages. Copy changes live in the CMS seed
# (db/content_seed/content.json) and are not asserted here.
RSpec.describe "Client audit — Oct 2026", type: :request do
  describe "header" do
    it "adds Home first and Contact last, and drops the separate Inquire button" do
      get "/"
      nav = response.body[/<nav class="site-nav".*?<\/nav>/m]
      expect(nav).to match(%r{<a href="/">Home</a>\s*<a href="/the-clinic">The Clinic</a>})
      expect(nav).to include('<a href="/inquire">Contact</a>')
      expect(response.body).not_to include("btn-inquire")
      expect(response.body).not_to include("btn btn--ghost\">Inquire")
    end

    it "uses the Arabic labels on /ar" do
      get "/ar"
      expect(response.body).to include(">الرئيسية</a>")
      expect(response.body).to include(">اتصل بنا</a>")
      expect(response.body).not_to include(">استفسري</a>")
    end
  end

  describe "home page" do
    before { get "/" }

    it "drops the closing CTA band and renders no reviews band without highlighted stories" do
      expect(response.body).not_to include('class="cta-band"')
      expect(response.body).not_to include("home-reviews")
    end

    it "fills the reviews band with stories that are visible and highlighted" do
      Story.create!(quote_en: "They told me what not to do.", quote_ar: "أخبروني بما لا أفعل.", byline_en: "L.M.", byline_ar: "ل.م.", position: 1, highlighted: true)
      Story.create!(quote_en: "Visible but not highlighted", quote_ar: "ظاهرة", position: 2)
      Story.create!(quote_en: "Highlighted but hidden", quote_ar: "مخفية", position: 3, hidden: true, highlighted: true)
      get "/"
      expect(response.body).to include('class="section section--light home-reviews"')
      expect(response.body).to include("They told me what not to do.")
      expect(response.body).not_to include("Visible but not highlighted")
      expect(response.body).not_to include("Highlighted but hidden")
      expect(response.body).to include('<a class="arrowlink" href="/stories">All patient stories →</a>')
    end

    it "promotes the protocols label to h2 and demotes the sentence to h3" do
      expect(response.body).to include('<h2 class="eyebrow">')
      expect(response.body).to include('<h3 class="sec-title"')
    end

    it "renders the About section heading as an h2" do
      expect(response.body).to match(%r{<h2 class="sec-title-md">About NeuSkin</h2>})
    end

    it "puts an icon in front of every footer visit line" do
      footer = response.body[/<div class="footer-visit">.*?<\/div>/m]
      expect(footer.scan('<p class="footer-line').size).to eq(5)
      expect(footer.scan("<svg").size).to eq(5)
    end
  end

  describe "clinic page" do
    before { get "/the-clinic" }

    it "replaces the statement with a numbered list beside the photo" do
      expect(response.body).not_to include("clinic-statement")
      expect(response.body).to include('<ol class="clinic-points">')
      expect(response.body.scan("<li data-reveal").size).to eq(3)
    end

    it "renders the gallery as a moving strip with the label as h2" do
      expect(response.body).to include('<h2 class="sec-title-md reveal"')
      expect(response.body).to include('class="photo-marquee-track"')
      # two copies of the five fallback shots for the seamless loop
      expect(response.body.scan('class="shot pm-shot"').size).to eq(10)
    end
  end
end
