require "rails_helper"

# Dashboard: The Space album is edited one photo at a time — each photo has
# its own caption fields and a Delete button; "Add a photo" takes one file
# plus its captions.
RSpec.describe "Admin section photos", type: :request do
  let(:png) { Vips::Image.black(20, 20).write_to_buffer(".png") }
  let(:section) { Section.create!(page: "the_clinic", kind: "clinic_space", label: "The Space") }

  before { sign_in create(:user) }

  def upload
    Rack::Test::UploadedFile.new(StringIO.new(png), "image/png", original_filename: "new.png")
  end

  def add_photo!(caption_en: "", caption_ar: "")
    photo = section.photos.create!(caption_en: caption_en, caption_ar: caption_ar)
    photo.image.attach(io: StringIO.new(png), filename: "shot.png", content_type: "image/png")
    photo
  end

  it "renders a card per photo with caption fields, a delete button and a single add-photo field" do
    photo = add_photo!(caption_en: "The lounge", caption_ar: "الصالة")
    get "/admin/sections/#{section.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(%(name="section[photos_attributes][0][caption_en]"))
    expect(response.body).to include(%(name="section[photos_attributes][0][caption_ar]"))
    expect(response.body).to include("The lounge")
    expect(response.body).to include("/admin/sections/#{section.id}/photos/#{photo.id}")
    expect(response.body).to include(%(name="section[new_photo][image]"))
    expect(response.body).to include(%(name="section[new_photo][caption_en]"))
    expect(response.body).not_to include(%(name="section[gallery_add][]"))
    expect(response.body).not_to include(%(name="section[gallery][]"))
  end

  it "shows the add-photo field even when the album is empty" do
    get "/admin/sections/#{section.id}"
    expect(response.body).to include(%(name="section[new_photo][image]"))
  end

  it "keeps the multi-image gallery fields for other gallery sections" do
    other = Section.create!(page: "home", kind: "home_clinic", label: "Inside")
    other.gallery.attach(io: StringIO.new(png), filename: "a.png", content_type: "image/png")
    get "/admin/sections/#{other.id}"
    expect(response.body).to include(%(name="section[gallery_add][]"))
    expect(response.body).not_to include(%(name="section[new_photo][image]"))
  end

  it "adds one photo with its captions" do
    add_photo!(caption_en: "First")
    patch "/admin/sections/#{section.id}", params: {
      section: { label: "The Space",
                 new_photo: { image: upload, caption_en: "Entrance", caption_ar: "المدخل" } }
    }
    expect(response).to redirect_to("/admin/sections/#{section.id}")
    expect(section.photos.count).to eq(2)
    added = section.photos.order(:position).last
    expect(added.caption_en).to eq("Entrance")
    expect(added.caption_ar).to eq("المدخل")
    expect(added.image).to be_attached
    expect(added.position).to eq(1)
  end

  it "rejects a new photo without a file" do
    patch "/admin/sections/#{section.id}", params: {
      section: { label: "The Space", new_photo: { caption_en: "No file" } }
    }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Choose an image")
    expect(section.photos.count).to eq(0)
  end

  it "updates captions of existing photos" do
    photo = add_photo!(caption_en: "Old")
    patch "/admin/sections/#{section.id}", params: {
      section: { label: "The Space",
                 photos_attributes: { "0" => { id: photo.id, caption_en: "New", caption_ar: "جديد" } } }
    }
    expect(response).to redirect_to("/admin/sections/#{section.id}")
    expect(photo.reload.caption_en).to eq("New")
    expect(photo.caption_ar).to eq("جديد")
  end

  it "deletes a photo and its file" do
    photo = add_photo!(caption_en: "Bye")
    blob_id = photo.image.blob.id
    delete "/admin/sections/#{section.id}/photos/#{photo.id}"
    expect(response).to redirect_to("/admin/sections/#{section.id}")
    expect(SectionPhoto.exists?(photo.id)).to be(false)
    expect(ActiveStorage::Blob.exists?(blob_id)).to be(false)
  end

  it "previews unsaved caption edits in the live preview" do
    photo = add_photo!(caption_en: "Saved caption")
    post "/admin/sections/#{section.id}/preview", params: {
      section: { label: "The Space",
                 photos_attributes: { "0" => { id: photo.id, caption_en: "Draft caption", caption_ar: "" } },
                 new_photo: { caption_en: "ignored" } }
    }
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Draft caption")
    expect(photo.reload.caption_en).to eq("Saved caption")
  end
end
