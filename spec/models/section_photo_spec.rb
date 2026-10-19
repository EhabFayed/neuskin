require "rails_helper"

RSpec.describe SectionPhoto, type: :model do
  let(:section) { create(:section, page: "the_clinic", kind: "clinic_space") }

  it "belongs to a section and orders by position" do
    b = section.photos.create!(position: 2, caption_en: "B")
    a = section.photos.create!(position: 1, caption_en: "A")
    expect(section.reload.photos).to eq([ a, b ])
  end

  it "returns the caption for the current locale" do
    photo = section.photos.create!(caption_en: "Lounge", caption_ar: "الصالة")
    expect(photo.caption).to eq("Lounge")
    I18n.with_locale(:ar) { expect(photo.caption).to eq("الصالة") }
  end

  it "falls back to the English caption on Arabic when Arabic is blank" do
    photo = section.photos.create!(caption_en: "Lounge", caption_ar: "")
    I18n.with_locale(:ar) { expect(photo.caption).to eq("Lounge") }
  end

  it "is destroyed with its section" do
    section.photos.create!(caption_en: "X")
    expect { section.destroy }.to change(SectionPhoto, :count).by(-1)
  end
end
