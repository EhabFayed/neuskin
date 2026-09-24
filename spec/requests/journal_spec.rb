require "rails_helper"

RSpec.describe "Journal", type: :request do
  def make_blog(attrs = {})
    blog = Blog.new({
      title_en: "A quiet room, by design", title_ar: "غرفة هادئة، عن قصد",
      excerpt_en: "How the clinic was drawn.", excerpt_ar: "كيف رُسمت العيادة.",
      category: "inside_clinic", is_published: true
    }.merge(attrs))
    blog.contents.build(key: "para_1", position: 1,
                        value_en: "Privacy is the floor plan.",
                        value_ar: "الخصوصية هي مخطط المبنى.")
    blog.save!
    blog
  end

  describe "editable hero" do
    it "renders admin-edited section copy over the yml default" do
      section = Section.create!(page: "journal", kind: "journal_hero")
      section.contents.create!(key: "title_1", value_en: "Custom journal title", value_ar: "عنوان مخصص")
      get "/journal"
      expect(response.body).to include("Custom journal title")
      get "/ar/journal"
      expect(response.body).to include("عنوان مخصص")
    end

    it "falls back to the yml copy when no section exists" do
      get "/journal"
      expect(response.body).to include("Notes, quietly")
    end
  end

  describe "section preview (admin)" do
    before { sign_in create(:user) }

    it "renders the real page template for dynamic pages" do
      {
        "journal"  => "journal_hero",
        "the_team" => "team_hero",
        "stories"  => "story_hero",
        "faq"      => "faq_hero"
      }.each do |page, kind|
        section = Section.create!(page: page, kind: kind)
        get "/admin/sections/#{section.id}/preview", params: { section: { label: section.kind } }
        expect(response).to have_http_status(:ok), "preview failed for #{page}"
      end
    end
  end

  describe "index" do
    it "lists published posts and hides drafts" do
      live  = make_blog
      draft = make_blog(title_en: "Draft note", title_ar: "مسودة", is_published: false)
      get "/journal"
      expect(response.body).to include(live.title_en)
      expect(response.body).not_to include(draft.title_en)
    end
  end

  describe "show" do
    it "renders the article by English slug" do
      blog = make_blog
      get "/journal/#{blog.slug_en}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Privacy is the floor plan.")
    end

    it "renders Arabic by Arabic slug under /ar" do
      blog = make_blog
      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("غرفة هادئة، عن قصد")
      expect(response.body).to include("الخصوصية هي مخطط المبنى.")
    end

    it "resolves either slug, but 301s to the slug of the page's own language" do
      blog = make_blog
      get "/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/journal/#{blog.slug_en}")
    end

    it "never shows a draft — it is sent home like any unknown URL (301)" do
      draft = make_blog(is_published: false)
      get "/journal/#{draft.slug_en}"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/")
    end
  end

  describe "show — FAQ section" do
    let(:faqs) do
      [
        { "q_en" => "Does it hurt?", "q_ar" => "هل يؤلم؟",
          "a_en" => "A numbing cream is applied first.", "a_ar" => "يُوضع كريم مخدر أولاً." },
        { "q_en" => "How soon can I fly?", "q_ar" => "متى أستطيع السفر؟",
          "a_en" => "The next day.", "a_ar" => "في اليوم التالي." }
      ]
    end

    it "renders the accordion and FAQPage JSON-LD in English" do
      blog = make_blog(faqs: faqs)
      get "/journal/#{blog.slug_en}"
      expect(response.body).to include('class="jra-faq"')
      expect(response.body).to include("Frequently asked")
      expect(response.body).to include('<details class="faq">')
      expect(response.body).to include("Does it hurt?")
      expect(response.body).to include("A numbing cream is applied first.")
      expect(response.body).not_to include("هل يؤلم؟")

      json = response.body[%r{<script type="application/ld\+json">\s*(\{.*?\})\s*</script>}m, 1]
      data = JSON.parse(json)
      expect(data["@type"]).to eq("FAQPage")
      expect(data["mainEntity"].map { |q| q["name"] }).to eq([ "Does it hurt?", "How soon can I fly?" ])
      expect(data["mainEntity"].first["acceptedAnswer"]["text"]).to eq("A numbing cream is applied first.")
    end

    it "renders the Arabic questions under /ar" do
      blog = make_blog(faqs: faqs)
      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response.body).to include("الأسئلة الشائعة")
      expect(response.body).to include("هل يؤلم؟")
      expect(response.body).to include("يُوضع كريم مخدر أولاً.")
      expect(response.body).not_to include("Does it hurt?")
    end

    it "skips the section entirely when there are no FAQs" do
      blog = make_blog
      get "/journal/#{blog.slug_en}"
      expect(response.body).not_to include("jra-faq")
      expect(response.body).not_to include("FAQPage")
    end

    it "skips rows with no question in the active locale" do
      blog = make_blog(faqs: [ { "q_en" => "English only", "q_ar" => "", "a_en" => "Yes", "a_ar" => "" } ])
      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response.body).not_to include("jra-faq")
    end
  end

  describe "show — booking aside" do
    it "renders the inquiry form and WhatsApp link beside the article" do
      blog = make_blog
      get "/journal/#{blog.slug_en}"
      expect(response.body).to include('class="jra-layout"')
      expect(response.body).to include('class="jra-aside"')
      expect(response.body).to include("Book a consultation")
      expect(response.body).to include("form--compact")
      expect(response.body).to include("Speak on WhatsApp")
      expect(response.body).to include("wa.me")
    end

    it "lazy-loads paragraph photos" do
      blog = make_blog
      blog.contents.first.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/pixel.png")),
                                       filename: "para.png")
      get "/journal/#{blog.slug_en}"
      expect(response.body).to match(/<img[^>]+loading="lazy"[^>]+para\.png|<img[^>]+para\.png[^>]+loading="lazy"/)
    end
  end

  describe "article body" do
    let(:png) { Vips::Image.black(8, 8).write_to_buffer(".png") }

    it "keeps a paragraph photo's alt text on the image without showing it as a caption" do
      blog = make_blog
      para = blog.contents.first
      para.update!(alt_en: "Treatment room, north light", alt_ar: "غرفة العلاج")
      para.photo.attach(io: StringIO.new(png), filename: "room.png", content_type: "image/png")

      get "/journal/#{blog.slug_en}"
      expect(response.body).to include('alt="Treatment room, north light"')
      expect(response.body).not_to include("<figcaption")
    end

    it "turns pasted non-breaking spaces into plain spaces so words wrap at line ends" do
      blog = make_blog
      blog.contents.first.update!(value_en: "<p>Hair&nbsp;care\u00A0basics&nbsp;first.</p>")

      get "/journal/#{blog.slug_en}"
      expect(response.body).to include("<p>Hair care basics first.</p>")
    end
  end

  describe "admin" do
    before { sign_in create(:user) }

    it "creates a post with paragraphs" do
      post "/admin/blogs", params: { blog: {
        title_en: "New note", title_ar: "تدوينة جديدة",
        excerpt_en: "x", excerpt_ar: "س", category: "ritual", is_published: "1",
        contents_attributes: { "0" => { value_en: "Body EN", value_ar: "نص عربي", position: 1 } }
      } }
      blog = Blog.find_by(title_en: "New note")
      expect(blog).to be_present
      expect(blog.slug_en).to eq("new-note")
      expect(blog.slug_ar).to be_present
      expect(blog.contents.count).to eq(1)
      expect(response).to redirect_to("/admin/blogs/#{blog.slug_en}/edit")
    end

    it "lists posts" do
      make_blog
      get "/admin/blogs"
      expect(response.body).to include("A quiet room, by design")
    end

    it "saves FAQ rows and drops blank ones" do
      post "/admin/blogs", params: { blog: {
        title_en: "FAQ note", title_ar: "تدوينة أسئلة", category: "ritual", is_published: "1",
        faqs_submitted: "1",
        faqs: [
          { q_en: " Does it hurt? ", q_ar: "هل يؤلم؟", a_en: "No.", a_ar: "لا." },
          { q_en: "", q_ar: "", a_en: "", a_ar: "" },
          { q_en: "English only", q_ar: "", a_en: "", a_ar: "" }
        ],
        contents_attributes: { "0" => { value_en: "Body", value_ar: "نص", position: 1 } }
      } }
      blog = Blog.find_by(title_en: "FAQ note")
      expect(blog.faqs).to eq([
        { "q_en" => "Does it hurt?", "q_ar" => "هل يؤلم؟", "a_en" => "No.", "a_ar" => "لا." },
        { "q_en" => "English only", "q_ar" => "", "a_en" => "", "a_ar" => "" }
      ])
    end

    it "clears FAQs when the form submits none, and leaves them alone when the key is absent" do
      blog = make_blog(faqs: [ { "q_en" => "Q", "q_ar" => "س", "a_en" => "A", "a_ar" => "ج" } ])

      patch "/admin/blogs/#{blog.slug_en}", params: { blog: { title_en: blog.title_en, title_ar: blog.title_ar } }
      expect(blog.reload.faqs.size).to eq(1)

      patch "/admin/blogs/#{blog.slug_en}", params: { blog: { title_en: blog.title_en, title_ar: blog.title_ar, faqs_submitted: "1" } }
      expect(blog.reload.faqs).to eq([])
    end

    it "shows the FAQ card and the RTE image tool on the edit form" do
      blog = make_blog(faqs: [ { "q_en" => "Existing Q", "q_ar" => "سؤال", "a_en" => "A", "a_ar" => "ج" } ])
      get "/admin/blogs/#{blog.slug_en}/edit"
      expect(response.body).to include("Frequently asked")
      expect(response.body).to include('value="Existing Q"')
      expect(response.body).to include("blog-faq-template")
    end

    it "removes the cover image when the checkbox is ticked" do
      blog = make_blog
      blog.image.attach(io: File.open(Rails.root.join("spec/fixtures/files/pixel.png")),
                        filename: "cover.png")
      patch "/admin/blogs/#{blog.slug_en}",
            params: { blog: { title_en: blog.title_en, title_ar: blog.title_ar },
                      remove_image: "0" }.deep_merge(blog: { remove_image: "1" })
      expect(blog.reload.image).not_to be_attached
    end

    it "attaches and removes a paragraph image" do
      blog = make_blog
      content = blog.contents.first

      patch "/admin/blogs/#{blog.slug_en}", params: { blog: {
        title_en: blog.title_en, title_ar: blog.title_ar,
        contents_attributes: { "0" => {
          id: content.id,
          photo: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/pixel.png"), "image/png"),
          alt_en: "A quiet corridor", alt_ar: "ممر هادئ"
        } }
      } }
      expect(content.reload.photo).to be_attached

      # the paragraph image (and its Arabic alt) render on the public article
      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response.body).to include("jra-figure")
      expect(response.body).to include("ممر هادئ")

      patch "/admin/blogs/#{blog.slug_en}", params: { blog: {
        title_en: blog.title_en, title_ar: blog.title_ar,
        contents_attributes: { "0" => { id: content.id, remove_photo: "1" } }
      } }
      expect(content.reload.photo).not_to be_attached
    end
  end
end
