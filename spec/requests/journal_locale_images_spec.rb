require "rails_helper"

# Client follow-up (Sept 2026): an article's artwork often carries text, so
# each language needs its own file. `image` / `photo` are the default (and the
# English) images; `image_ar` / `photo_ar` are optional Arabic replacements.
RSpec.describe "Journal images per locale", type: :request do
  def png(w = 20) = Vips::Image.black(w, w).write_to_buffer(".png")

  def blob(name)
    ActiveStorage::Blob.create_and_upload!(io: StringIO.new(png), filename: name, content_type: "image/png")
  end

  let(:blog) do
    b = Blog.new(title_en: "Reading skin", title_ar: "قراءة البشرة",
                 excerpt_en: "Why we read first.", excerpt_ar: "لماذا نقرأ أولًا.",
                 is_published: true)
    b.contents.build(key: "para_1", position: 1, value_en: "Body.", value_ar: "النص.")
    b.save!
    b
  end

  # The rendered variant URL carries the blob's key, so each file is
  # identifiable in the HTML.
  def variant_shown?(body, blob)
    body.include?(blob.key) ||
      body.scan(%r{/rails/active_storage/representations/[^"']+}).any? do |url|
        url.include?(blob.key)
      end
  end

  describe "cover" do
    before do
      blog.image.attach(blob("cover-en.png"))
      blog.image_ar.attach(blob("cover-ar.png"))
    end

    it "shows the Arabic cover on Arabic pages and the English one on English pages" do
      get "/journal/#{blog.slug_en}"
      expect(response.body).to include("cover-en").or include(blog.image.blob.key)
      expect(response.body).not_to include("cover-ar")

      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response.body).to include("cover-ar").or include(blog.image_ar.blob.key)
      expect(response.body).not_to include("cover-en")
    end

    it "uses the same Arabic cover on the Journal grid and the home band" do
      get "/ar/journal"
      expect(response.body).to include("cover-ar").or include(blog.image_ar.blob.key)
      get "/ar"
      expect(response.body).to include("cover-ar").or include(blog.image_ar.blob.key)
    end
  end

  it "falls back to the English cover when no Arabic one is attached" do
    blog.image.attach(blob("only-en.png"))
    get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
    expect(response.body).to include("only-en").or include(blog.image.blob.key)
  end

  describe "paragraph images" do
    let(:para) { blog.contents.first }

    it "swaps the paragraph image per locale, falling back to the English file" do
      para.photo.attach(blob("para-en.png"))
      get "/journal/#{blog.slug_en}"
      expect(response.body).to include("para-en").or include(para.photo.blob.key)
      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response.body).to include("para-en").or include(para.photo.blob.key)

      para.photo_ar.attach(blob("para-ar.png"))
      get "/ar/journal/#{ERB::Util.url_encode(blog.slug_ar)}"
      expect(response.body).to include("para-ar").or include(para.photo_ar.blob.key)
      expect(response.body).not_to include("para-en")
    end
  end

  describe "the Studio form" do
    let(:admin) { User.create!(email: "loc@neuskin.test", password: "changeme123", role: "admin") }
    before { sign_in admin }

    it "offers an English and an Arabic slot for the cover and every paragraph" do
      get "/admin/blogs/#{blog.slug_en}/edit"
      expect(response.body).to include('name="blog[image]"').and include('name="blog[image_ar]"')
      expect(response.body).to include("[photo]").and include("[photo_ar]")
      expect(response.body).to include('name="blog[remove_image_ar]"')
    end

    it "attaches and purges the Arabic files independently of the English ones" do
      blog.image.attach(blob("keep-en.png"))
      file = Rack::Test::UploadedFile.new(StringIO.new(png), "image/png", original_filename: "new-ar.png")
      patch "/admin/blogs/#{blog.slug_en}", params: { blog: { title_en: blog.title_en, image_ar: file } }
      expect(blog.reload.image_ar.filename.to_s).to eq("new-ar.png")
      expect(blog.image.filename.to_s).to eq("keep-en.png")

      patch "/admin/blogs/#{blog.slug_en}", params: { blog: { title_en: blog.title_en, remove_image_ar: "1" } }
      expect(blog.reload.image_ar).not_to be_attached
      expect(blog.image).to be_attached
    end

    it "keeps a replacement Arabic paragraph image even with a stale remove flag" do
      para = blog.contents.first
      para.photo_ar.attach(blob("old-ar.png"))
      file = Rack::Test::UploadedFile.new(StringIO.new(png), "image/png", original_filename: "fresh-ar.png")
      patch "/admin/blogs/#{blog.slug_en}", params: { blog: {
        title_en: blog.title_en,
        contents_attributes: { "0" => { id: para.id, photo_ar: file, remove_photo_ar: "1" } }
      } }
      expect(para.reload.photo_ar.filename.to_s).to eq("fresh-ar.png")
    end
  end
end
