require "rails_helper"

RSpec.describe ContentHelper, type: :helper do
  describe "#sec_text" do
    it "returns the English value for an existing content" do
      section = create(:section, page: "home", kind: "home_hero")
      create(:content, parentable: section, key: "headline",
             value_en: "Hello", value_ar: "مرحبا")
      I18n.with_locale(:en) do
        expect(helper.sec_text("home", "home_hero", "headline")).to eq("Hello")
      end
    end

    it "returns the Arabic value in the Arabic locale" do
      section = create(:section, page: "home", kind: "home_hero")
      create(:content, parentable: section, key: "headline",
             value_en: "Hello", value_ar: "مرحبا")
      I18n.with_locale(:ar) do
        expect(helper.sec_text("home", "home_hero", "headline")).to eq("مرحبا")
      end
    end

    it "returns empty string when the section is missing" do
      expect(helper.sec_text("home", "nope", "headline")).to eq("")
    end

    it "returns empty string when the key is missing" do
      create(:section, page: "home", kind: "home_hero")
      expect(helper.sec_text("home", "home_hero", "absent")).to eq("")
    end
  end

  describe "#sec_items" do
    it "returns the items array" do
      create(:section, page: "home", kind: "home_voices",
             items: [{ "q" => { "en" => "hi" } }])
      expect(helper.sec_items("home", "home_voices")).to eq([{ "q" => { "en" => "hi" } }])
    end

    it "returns [] when the section is missing" do
      expect(helper.sec_items("home", "nope")).to eq([])
    end
  end

  describe "#sec_image" do
    it "falls back to the static asset when no image is attached" do
      create(:section, page: "home", kind: "home_hero")
      # ns_image returns an asset path string; just assert it is non-blank.
      expect(helper.sec_image("home", "home_hero", :portrait_natural)).to be_present
    end
  end
end
