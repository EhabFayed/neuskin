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

  describe "chrome translation" do
    it "renders the nav and footer in Arabic under /ar" do
      get "/ar"
      expect(response.body).to include("العيادة")          # nav: The Clinic
      expect(response.body).to include("استفسري")          # header Inquire button
      expect(response.body).to include("الفريق الطبي")     # footer: The Medical Team
      expect(response.body).to include("الجمعة · مغلق")    # footer: Friday · Closed
    end

    it "keeps the English nav and footer unchanged" do
      get "/"
      expect(response.body).to include(">The Clinic<")
      expect(response.body).to include(">Inquire<")
      expect(response.body).to include("The Medical Team")
      expect(response.body).to include("© #{Time.current.year} NeuSkin Clinic · SFDA / MOH licensed")
    end
  end
end
