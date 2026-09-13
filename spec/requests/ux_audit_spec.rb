require "rails_helper"

# Client UX audit, Sept 2026 — behaviour the fixes must keep.
RSpec.describe "UX audit fixes", type: :request do
  before do
    Protocol.create!(slug: "brides-180", name_en: "Bride's 180", name_ar: "العروس ١٨٠", duration_en: "180 days", duration_ar: "١٨٠ يومًا")
    Treatment.create!(slug: "skin", title_en: "Skin", title_ar: "البشرة", headline_en: "Tired skin", headline_ar: "بشرة متعبة")
    Device.create!(name: "EMFACE", tagline_en: "Needle-free lift", tagline_ar: "شدّ بلا إبر")
    3.times do |i|
      Blog.create!(title_en: "Note #{i}", title_ar: "تدوينة #{i}", is_published: true, created_at: i.hours.ago)
    end
    Blog.create!(title_en: "Draft", title_ar: "مسودة", is_published: false)
  end

  describe "header (items 9 + 12)" do
    it "lists every protocol, treatment and device in submenus, with the booking button" do
      get "/"
      expect(response.body).to include('href="/protocols/brides-180"')
      expect(response.body).to include('href="/treatments/skin"')
      expect(response.body).to include('href="/technologies/emface"')
      expect(response.body).to include("workstation.repzo.com")
      expect(response.body).to include('class="btn-book"')
      expect(response.body).to include('class="nav-burger"')
    end

    it "replaces the floating booking pill with a WhatsApp button" do
      get "/"
      expect(response.body).to include('class="floating-wa"')
      expect(response.body).not_to include("floating-book")
    end
  end

  describe "home page (items 8, 10, 13)" do
    it "shows the three latest published notes above the footer" do
      get "/"
      expect(response.body).to include("home-journal")
      expect(response.body).to include("Note 0").and include("Note 1").and include("Note 2")
      expect(response.body).not_to include(">Draft<")
    end

    it "renders the hero CTAs, marquee and protocol names in Arabic under /ar" do
      get "/ar"
      expect(response.body).to include("اطلبي تقييمكِ")
      expect(response.body).to include("بروتوكولات لا قوائم")
      expect(response.body).to include("العروس ١٨٠")
      expect(response.body).not_to include("Speak privately on WhatsApp")
      expect(response.body).not_to include("Explore this protocol")
    end

    it "ships a poster-first hero instead of the 13 MB clip" do
      get "/"
      expect(response.body).to match(/hero-poster(-[a-f0-9]+)?\.webp/)
      expect(response.body).to include('data-controller="herovideo"')
      expect(response.body).not_to include("neuskin-web-data.mp4")
    end
  end

  describe "inquiry page (item 5 + technical)" do
    it "is fully Arabic under /ar" do
      get "/ar/inquire"
      expect(response.body).to include("أرسلي الاستفسار")
      expect(response.body).to include("وقت التواصل المفضّل")
      expect(response.body).not_to include("Send inquiry")
      expect(response.body).not_to include("Preferred contact time")
    end

    it "keeps prefilled variants out of the index while the bare URL stays indexable" do
      get "/inquire", params: { codeword: "BRIDE", persona: "bride" }
      expect(response.body).to include('name="robots" content="noindex, follow"')
      expect(response.body).to include('<link rel="canonical" href="http://www.example.com/inquire">')
      get "/inquire"
      expect(response.body).not_to include('name="robots"')
    end
  end

  describe "protocol page (item 10)" do
    it "has no English chrome on the Arabic page" do
      get "/ar/protocols/brides-180"
      expect(response.body).to include("اطلبي خطتكِ")
      expect(response.body).to include("رحلة المريضة")
      expect(response.body).not_to include("Request your plan")
      expect(response.body).not_to include("The patient journey")
    end
  end

  describe "device pages (client follow-up)" do
    it "gives every device its own page in both locales" do
      get "/technologies/emface"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("EMFACE").and include("Needle-free lift")
      get "/ar/technologies/emface"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("شدّ بلا إبر")
      get "/technologies/nope"
      expect(response).to have_http_status(:moved_permanently)
    end
  end

  describe "footer (item 6)" do
    it "links the clinic location on Google Maps" do
      get "/"
      expect(response.body).to include('class="footer-map-link"')
      expect(response.body).to include("google.com/maps")
    end
  end

  describe "unknown URLs (technical)" do
    it "301s unknown paths to the homepage, keeping the locale" do
      get "/some/old/page"
      expect(response).to redirect_to("/")
      expect(response).to have_http_status(:moved_permanently)
      get "/ar/some/old/page"
      expect(response).to redirect_to("/ar")
      expect(response).to have_http_status(:moved_permanently)
    end

    it "301s a missing journal slug home" do
      get "/journal/does-not-exist"
      expect(response).to have_http_status(:moved_permanently)
    end

    it "leaves the health check and admin 404s alone" do
      get "/up"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "images (items 1–3)" do
    it "rewrites editor-uploaded article images to WebP variants" do
      png = Vips::Image.black(30, 30).write_to_buffer(".png")
      blob = ActiveStorage::Blob.create_and_upload!(io: StringIO.new(png), filename: "inline.png", content_type: "image/png")
      blog = Blog.create!(title_en: "Pic", title_ar: "صورة", is_published: true)
      blog.contents.create!(key: "para_1", position: 1,
                            value_en: %(<p>Hi</p><img src="/rails/active_storage/blobs/proxy/#{blob.signed_id}/inline.png">))
      get "/journal/pic"
      expect(response.body).to include("/rails/active_storage/representations/")
      expect(response.body).not_to include("/rails/active_storage/blobs/proxy/#{blob.signed_id}")
      expect(response.body).to include('loading="lazy"')
    end

    it "serves dashboard images as resized WebP variants" do
      t = Treatment.first
      png = Vips::Image.black(40, 40).write_to_buffer(".png")
      t.image.attach(io: StringIO.new(png), filename: "big.png", content_type: "image/png")
      get "/treatments"
      expect(response.body).to include("/rails/active_storage/representations/")
      expect(response.body).not_to include("/rails/active_storage/blobs/")
    end
  end
end
