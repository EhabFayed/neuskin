require "rails_helper"

# Studio image fields: thumbnail + preview + Remove (flag purged on save).
RSpec.describe "Admin image fields", type: :request do
  let(:admin) { User.create!(email: "img@neuskin.test", password: "changeme123", role: "admin") }
  let(:png)   { Vips::Image.black(20, 20).write_to_buffer(".png") }

  before { sign_in admin }

  def attach!(record, attr)
    record.public_send(attr).attach(io: StringIO.new(png), filename: "x.png", content_type: "image/png")
  end

  it "renders the field with the current thumbnail and a Remove button" do
    p = Protocol.create!(slug: "p1", name_en: "P1", name_ar: "ب١")
    attach!(p, :image)
    get "/admin/protocols/#{p.slug}/edit"
    expect(response.body).to include('data-controller="imagefield"')
    expect(response.body).to include("/rails/active_storage/blobs/")
    expect(response.body).to include('name="protocol[remove_image]"')
    expect(response.body).to include(">Remove<")
  end

  it "purges a protocol image when the remove flag is set" do
    p = Protocol.create!(slug: "p2", name_en: "P2", name_ar: "ب٢")
    attach!(p, :image)
    patch "/admin/protocols/#{p.slug}", params: { protocol: { name_en: "P2", remove_image: "1" } }
    expect(p.reload.image).not_to be_attached
  end

  it "keeps a freshly uploaded image even if the stale remove flag is set" do
    p = Protocol.create!(slug: "p3", name_en: "P3", name_ar: "ب٣")
    attach!(p, :image)
    file = Rack::Test::UploadedFile.new(StringIO.new(png), "image/png", original_filename: "new.png")
    patch "/admin/protocols/#{p.slug}", params: { protocol: { name_en: "P3", remove_image: "1", image: file } }
    expect(p.reload.image).to be_attached
    expect(p.image.filename.to_s).to eq("new.png")
  end

  it "purges device and section slot images via their flags" do
    d = Device.create!(name: "ZZZ")
    attach!(d, :front_image)
    patch "/admin/devices/#{d.id}", params: { device: { name: "ZZZ", remove_front_image: "1" } }
    expect(d.reload.front_image).not_to be_attached

    s = Section.create!(page: "home", kind: "home_principles")
    attach!(s, :card_image_2)
    patch "/admin/sections/#{s.id}", params: { section: { label: "x", remove_card_image_2: "1" } }
    expect(s.reload.card_image_2).not_to be_attached
  end
end
