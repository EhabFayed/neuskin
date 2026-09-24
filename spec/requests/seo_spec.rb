require "rails_helper"

# Technical SEO (Sept 2026 audit): one indexable URL per language, a unique
# title + description on every page (dashboard-editable), self-referencing
# hreflang that always points at the same language's own slug, three distinct
# legal documents, and robots.txt / sitemap.xml rendered by the app.
RSpec.describe "Technical SEO", type: :request do
  def make_blog(**attrs)
    Blog.create!({
      title_en: "A quiet room", title_ar: "غرفة هادئة",
      slug_en: "a-quiet-room", slug_ar: "غرفة-هادئة",
      excerpt_en: "Privacy is the floor plan.", excerpt_ar: "الخصوصية هي مخطط المبنى.",
      is_published: true
    }.merge(attrs))
  end

  def encoded(slug) = ERB::Util.url_encode(slug)

  STATIC_PAGES = %w[
    / /the-clinic /journal /stories /faq /privacy /medical-disclaimer /terms
    /the-team /neuskin-method /technologies /treatments /private-care /protocols
    /inquire /bridal-concierge
  ].freeze

  describe "robots.txt" do
    it "is rendered by the app as text with a one-hour public cache" do
      get "/robots.txt"
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/plain")
      expect(response.body).to include("Disallow: /admin/").and include("Disallow: /cdn-cgi/")
      expect(response.body).to include("Sitemap: http://www.example.com/sitemap.xml")
      expect(response.headers["Cache-Control"]).to include("max-age=3600").and include("public")
    end
  end

  describe "sitemap.xml" do
    it "lists every page in both languages with hreflang alternates" do
      Protocol.create!(slug: "bare", name_en: "Bare", name_ar: "الأدنى")
      Treatment.create!(slug: "bare-skin", title_en: "Skin", headline_en: "Bare skin")
      Device.create!(name: "EMFACE")
      get "/sitemap.xml"
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/xml")
      expect(response.headers["Cache-Control"]).to include("max-age=3600")
      expect(response.body).to include("<loc>http://www.example.com/the-clinic</loc>")
      expect(response.body).to include("<loc>http://www.example.com/ar/the-clinic</loc>")
      expect(response.body).to include("<loc>http://www.example.com/protocols/bare</loc>")
      expect(response.body).to include("<loc>http://www.example.com/ar/treatments/bare-skin</loc>")
      expect(response.body).to include("<loc>http://www.example.com/ar/technologies/emface</loc>")
      expect(response.body).to include('hreflang="ar" href="http://www.example.com/ar/the-clinic"')
      expect(response.body).to include('hreflang="x-default" href="http://www.example.com/the-clinic"')
      expect(response.body).not_to include("/en/")
    end

    it "uses each language's own slug for journal articles and skips drafts" do
      blog = make_blog
      make_blog(title_en: "Draft", title_ar: "مسودة", slug_en: "draft-note", slug_ar: "مسودة", is_published: false)
      get "/sitemap.xml"
      expect(response.body).to include("<loc>http://www.example.com/journal/a-quiet-room</loc>")
      expect(response.body).to include("<loc>http://www.example.com/ar/journal/#{encoded(blog.slug_ar)}</loc>")
      expect(response.body).not_to include("/ar/journal/a-quiet-room")
      expect(response.body).not_to include("http://www.example.com/journal/#{encoded(blog.slug_ar)}")
      expect(response.body).not_to include("draft-note")
    end
  end

  describe "one URL per language" do
    it "301s the explicit /en prefix to the bare English path, keeping the query string" do
      get "/en"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/")
      get "/en/the-clinic"
      expect(response).to redirect_to("/the-clinic")
      get "/en/inquire", params: { persona: "bride" }
      expect(response).to redirect_to("/inquire?persona=bride")
    end

    it "leaves /ar untouched" do
      get "/ar/the-clinic"
      expect(response).to have_http_status(:ok)
    end

    it "301s a journal article reached under the other language's slug" do
      blog = make_blog
      get "/journal/#{encoded(blog.slug_ar)}"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/journal/a-quiet-room")
      get "/ar/journal/a-quiet-room"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/ar/journal/#{encoded(blog.slug_ar)}")
    end

    it "points hreflang, canonical and the language switch at each language's own slug" do
      blog = make_blog
      get "/ar/journal/#{encoded(blog.slug_ar)}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<link rel="canonical" href="http://www.example.com/ar/journal/' + encoded(blog.slug_ar) + '">')
      expect(response.body).to include('hreflang="en" href="http://www.example.com/journal/a-quiet-room"')
      expect(response.body).to include('hreflang="ar" href="http://www.example.com/ar/journal/' + encoded(blog.slug_ar) + '"')
      expect(response.body).to match(%r{locale-switch[^>]+href="/journal/a-quiet-room"})

      get "/journal/a-quiet-room"
      expect(response.body).to match(%r{locale-switch[^>]+href="/ar/journal/#{Regexp.escape(encoded(blog.slug_ar))}"})
    end
  end

  describe "titles and descriptions" do
    def title_and_description
      [ response.body[%r{<title>(.*?)</title>}m, 1], response.body[/<meta name="description" content="(.*?)">/, 1] ]
    end

    it "gives every static page its own title and description, in both languages" do
      [ "", "/ar" ].each do |prefix|
        titles = {}
        descriptions = {}
        STATIC_PAGES.each do |path|
          get "#{prefix}#{path == '/' ? '' : path}".presence || "/"
          expect(response).to have_http_status(:ok), "#{prefix}#{path} -> #{response.status}"
          title, description = title_and_description
          expect(title).to be_present
          expect(description).to be_present
          expect(titles[title]).to be_nil, "#{prefix}#{path} repeats the <title> of #{titles[title]}: #{title}"
          expect(descriptions[description]).to be_nil, "#{prefix}#{path} repeats the description of #{descriptions[description]}"
          titles[title] = "#{prefix}#{path}"
          descriptions[description] = "#{prefix}#{path}"
        end
      end
    end

    it "renders the Arabic title under /ar" do
      get "/ar/the-clinic"
      expect(response.body).to include("<title>العيادة — نيوسكن، الرياض</title>")
    end

    it "lets the dashboard override a page's title and description per language" do
      section = Section.create!(page: "the_clinic", kind: "seo", label: "Search preview (SEO)")
      section.contents.create!(key: "meta_title", value_en: "Custom clinic title", value_ar: "عنوان مخصّص")
      section.contents.create!(key: "meta_description", value_en: "Custom clinic description.")
      get "/the-clinic"
      expect(response.body).to include("<title>Custom clinic title</title>")
      expect(response.body).to include('<meta name="description" content="Custom clinic description.">')
      get "/ar/the-clinic"
      expect(response.body).to include("<title>عنوان مخصّص</title>")
    end

    it "keeps the three legal documents' overrides separate" do
      section = Section.create!(page: "legal", kind: "seo_terms", label: "SEO — Terms")
      section.contents.create!(key: "meta_title", value_en: "Custom terms title")
      get "/terms"
      expect(response.body).to include("<title>Custom terms title</title>")
      get "/privacy"
      expect(response.body).not_to include("Custom terms title")
    end

    it "uses a record's own meta fields on its page, else builds them from its content" do
      Protocol.create!(slug: "glow", name_en: "Glow", name_ar: "توهّج",
                       promise_en: "Skin that reads calm.", meta_title_en: "Glow Reset — 90 days")
      get "/protocols/glow"
      expect(response.body).to include("<title>Glow Reset — 90 days</title>")
      expect(response.body).to include('<meta name="description" content="Skin that reads calm.">')

      Treatment.create!(slug: "dull", title_en: "Dull", headline_en: "Tired, dull skin", look_en: "Flat tone.",
                        meta_description_en: "A written plan for dull skin.")
      get "/treatments/dull"
      expect(response.body).to include("<title>Tired, dull skin — NeuSkin Clinic</title>")
      expect(response.body).to include('<meta name="description" content="A written plan for dull skin.">')

      Device.create!(name: "EMTONE", tagline_en: "Harmonious Rejuvenation", meta_title_ar: "إمتون في نيوسكن")
      get "/technologies/emtone"
      expect(response.body).to include("<title>EMTONE at NeuSkin Clinic — Harmonious Rejuvenation</title>")
      get "/ar/technologies/emtone"
      expect(response.body).to include("<title>إمتون في نيوسكن</title>")
    end

    it "emits Open Graph tags carrying the page's locale and canonical URL" do
      get "/ar/faq"
      expect(response.body).to include('<meta property="og:locale" content="ar_SA">')
      expect(response.body).to include('<meta property="og:locale:alternate" content="en_US">')
      expect(response.body).to include('<meta property="og:url" content="http://www.example.com/ar/faq">')
      expect(response.body).to include('<meta property="og:type" content="website">')
      make_blog
      get "/journal/a-quiet-room"
      expect(response.body).to include('<meta property="og:type" content="article">')
    end
  end

  describe "legal documents" do
    it "renders three different documents, each with only its own sections" do
      get "/privacy"
      expect(response.body).to include("<span>Privacy Policy &amp; PDPL</span>")
      expect(response.body).to include("Your rights under the PDPL").and include("Consent policy")
      expect(response.body).not_to include("Not medical advice")
      expect(response.body).not_to include("Using the site")

      get "/medical-disclaimer"
      expect(response.body).to include("<span>Medical Advertising Disclaimer</span>")
      expect(response.body).to include("Not medical advice")
      expect(response.body).not_to include("Your rights under the PDPL")
      expect(response.body).not_to include("Consent policy")

      get "/terms"
      expect(response.body).to include("<span>Terms of Service &amp; Inquiry</span>")
      expect(response.body).to include("WhatsApp communication")
      expect(response.body).not_to include("Your rights under the PDPL")
    end

    it "renders the Arabic copy under /ar" do
      get "/ar/terms"
      expect(response.body).to include("شروط الاستخدام والاستفسار")
      expect(response.body).to include("التواصل عبر واتساب")
    end

    it "links each document to the other two" do
      get "/privacy"
      expect(response.body).to match(%r{href="/medical-disclaimer"}).and match(%r{href="/terms"})
      get "/ar/terms"
      expect(response.body).to match(%r{href="/ar/privacy"}).and match(%r{href="/ar/medical-disclaimer"})
    end
  end

  describe "footer email" do
    it "is wrapped in email_off so Cloudflare never rewrites it to /cdn-cgi/l/email-protection" do
      get "/"
      expect(response.body).to include('<!--email_off--><a href="mailto:hello@neuskin.sa"')
      expect(response.body).to include("<!--/email_off-->")
    end
  end
end
