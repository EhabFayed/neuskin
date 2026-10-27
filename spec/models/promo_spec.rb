require "rails_helper"

RSpec.describe Promo, type: :model do
  def build_promo(**attrs)
    Promo.new({ label_en: "SKIN BOOSTERS", percent: 30, code: "GLOW30",
                title_en: "Skin boosters, 30% off" }.merge(attrs))
  end

  it "stores the code upcased and without spaces" do
    promo = build_promo(code: " glow 30 ")
    expect(promo).to be_valid
    expect(promo.code).to eq("GLOW30")
  end

  it "rejects codes with punctuation other than - and _" do
    expect(build_promo(code: "GLOW 30!")).not_to be_valid
    expect(build_promo(code: "glow-30_b")).to be_valid
  end

  it "rejects duplicate codes regardless of case" do
    build_promo.save!
    expect(build_promo(code: "glow30")).not_to be_valid
  end

  it "keeps the percentage between 1 and 100" do
    expect(build_promo(percent: 0)).not_to be_valid
    expect(build_promo(percent: 101)).not_to be_valid
    expect(build_promo(percent: 100)).to be_valid
  end

  describe ".available" do
    it "lists active promos that still have uses left, in position order" do
      second   = build_promo(code: "B", position: 2).tap(&:save!)
      first    = build_promo(code: "A", position: 1, max_uses: 5, uses_count: 4).tap(&:save!)
      build_promo(code: "OFF", active: false).save!
      build_promo(code: "SPENT", max_uses: 2, uses_count: 2).save!

      expect(Promo.available).to eq([ first, second ])
    end
  end

  describe "#claim!" do
    it "counts a use while under the limit and stops at the limit" do
      promo = build_promo(max_uses: 2).tap(&:save!)

      expect(promo.claim!).to be(true)
      expect(promo.claim!).to be(true)
      expect(promo.claim!).to be(false)
      expect(promo.reload.uses_count).to eq(2)
      expect(promo).to be_exhausted
      expect(promo.remaining_uses).to eq(0)
    end

    it "never runs out when unlimited" do
      promo = build_promo.tap(&:save!)
      3.times { expect(promo.claim!).to be(true) }
      expect(promo.remaining_uses).to be_nil
      expect(promo).not_to be_exhausted
    end

    it "refuses an inactive promo" do
      promo = build_promo(active: false).tap(&:save!)
      expect(promo.claim!).to be(false)
      expect(promo.reload.uses_count).to eq(0)
    end
  end

  describe "#whatsapp_url" do
    it "prefills the reference message with the code" do
      promo = build_promo
      expect(promo.whatsapp_url).to start_with("https://wa.me/#{Clinic::WHATSAPP_NUMBER}?text=")
      expect(CGI.unescape(promo.whatsapp_url.split("text=").last))
        .to eq("Hello NeuSkin, I'd like to reserve my private glow. Code: GLOW30")
    end
  end

  it "falls back to English when Arabic copy is blank" do
    promo = build_promo(title_ar: "")
    I18n.with_locale(:ar) { expect(promo.title).to eq("Skin boosters, 30% off") }
    promo.title_ar = "خصم"
    I18n.with_locale(:ar) { expect(promo.title).to eq("خصم") }
  end
end
