require "rails_helper"

# The layout must flip writing direction with the locale so RTL pages mirror
# (hero media moves to the inline-end, i.e. visually left in Arabic).
RSpec.describe "Locale direction", type: :request do
  it "serves English LTR at the unprefixed root" do
    get "/"
    expect(response.body).to include('<html lang="en" dir="ltr">')
  end

  it "serves Arabic RTL under /ar" do
    get "/ar"
    expect(response.body).to include('<html lang="ar" dir="rtl">')
  end

  it "serves English LTR under the explicit /en prefix" do
    get "/en"
    expect(response.body).to include('<html lang="en" dir="ltr">')
  end

  describe "header language switcher" do
    it "links the English homepage to /ar" do
      get "/"
      expect(response.body).to match(%r{locale-switch[^>]+href="/ar"})
    end

    it "links an Arabic page back to its unprefixed English page" do
      get "/ar/protocols"
      expect(response.body).to match(%r{locale-switch[^>]+href="/protocols"})
    end

    it "keeps query params when switching" do
      get "/inquire", params: { persona: "unsure" }
      expect(response.body).to match(%r{locale-switch[^>]+href="/ar/inquire\?persona=unsure"})
    end
  end
end
