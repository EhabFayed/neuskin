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
  end
end
