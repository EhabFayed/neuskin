require "rails_helper"

# The Clinic → "The Space" album: one caption per photo (any number of
# photos), hidden behind a per-photo toggle button on the public page.
RSpec.describe "Clinic album captions", type: :request do
  let(:png) { Vips::Image.black(20, 20).write_to_buffer(".png") }

  def add_photo!(section, caption_en: "", caption_ar: "")
    photo = section.photos.create!(caption_en: caption_en, caption_ar: caption_ar)
    photo.image.attach(io: StringIO.new(png), filename: "shot.png", content_type: "image/png")
    photo
  end

  it "still renders the five fallback shots (twice) when no photo is attached" do
    get "/the-clinic"
    expect(response.body.scan('class="shot pm-shot"').size).to eq(10)
    expect(response.body.scan('class="pm-cap-btn"').size).to eq(10)
  end

  it "renders every attached photo with its own caption and toggle button" do
    section = Section.create!(page: "the_clinic", kind: "clinic_space", label: "The Space")
    6.times { |i| add_photo!(section, caption_en: "Caption number #{i + 1}", caption_ar: "تعليق #{i + 1}") }

    get "/the-clinic"
    expect(response.body.scan('class="shot pm-shot"').size).to eq(12)
    expect(response.body).to include("Caption number 6")
    expect(response.body).to include('data-controller="shotcap"')
    expect(response.body.scan('class="pm-cap-btn"').size).to eq(12)
    expect(response.body).to include('aria-expanded="false"')

    get "/ar/the-clinic"
    expect(response.body).to include("تعليق 6")
  end

  it "shows no caption and no toggle button for a photo without a caption" do
    section = Section.create!(page: "the_clinic", kind: "clinic_space", label: "The Space")
    add_photo!(section, caption_en: "Only one")
    add_photo!(section)

    get "/the-clinic"
    expect(response.body.scan('class="shot pm-shot"').size).to eq(4)
    expect(response.body.scan('class="pm-cap-btn"').size).to eq(2)
    expect(response.body.scan("<figcaption").size).to eq(2)
  end
end
