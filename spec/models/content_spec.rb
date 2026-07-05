require "rails_helper"

RSpec.describe Content, type: :model do
  it "requires a key" do
    expect(build(:content, key: nil)).not_to be_valid
  end

  describe "#value" do
    it "returns English outside Arabic locale" do
      c = build(:content, value_ar: "عربى", value_en: "English")
      I18n.with_locale(:en) { expect(c.value).to eq("English") }
    end

    it "returns Arabic in the Arabic locale" do
      c = build(:content, value_ar: "عربى", value_en: "English")
      I18n.with_locale(:ar) { expect(c.value).to eq("عربى") }
    end

    it "returns nil when the locale value is blank" do
      c = build(:content, value_ar: "", value_en: "English")
      I18n.with_locale(:ar) { expect(c.value).to be_nil }
    end
  end
end
