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

    it "resolves either slug regardless of locale (locale switcher keeps the path)" do
      blog = make_blog
      get "/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(blog.title_en)
    end

    it "404s a draft" do
      draft = make_blog(is_published: false)
      get "/journal/#{draft.slug_en}"
      expect(response).to have_http_status(:not_found)
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
