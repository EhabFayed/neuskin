require "rails_helper"

# Digital Gift Card — /promo, /promo/:code and the use-counting beacon.
RSpec.describe "Promo page", type: :request do
  let!(:boosters) do
    Promo.create!(label_en: "Skin Boosters", label_ar: "سكين بوسترز", percent: 30, code: "GLOW30",
                  title_en: "A Gift of Care", title_ar: "هدية من العناية",
                  description_en: "For someone special.", position: 1, max_uses: 2)
  end
  let!(:botox) do
    Promo.create!(label_en: "Botox", percent: 25, code: "GLOW25", title_en: "A Moment of Glow", position: 2)
  end

  it "opens the first live gift in the envelope, with no site chrome" do
    get "/promo"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-controller="envelope"')
    expect(response.body).to include("A Gift of Care")
    expect(response.body).to include("Skin Boosters · 30% off")
    expect(response.body).to include("GLOW30")
    expect(response.body).not_to include("GLOW25")
    expect(response.body).to include("Tap the seal to open")
    expect(response.body).to include("Reserve my private glow")
    expect(response.body).to include("/promo/GLOW30/claim")
    expect(response.body).to include("https://wa.me/#{Clinic::WHATSAPP_NUMBER}?text=")
    expect(response.body).to include("<title>A Gift Is Waiting for You")
    expect(response.body).not_to include("site-header")
    expect(response.body).not_to include("intro-splash")
  end

  it "opens a specific gift by its code, in any case" do
    get "/promo/glow25"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("A Moment of Glow")
    expect(response.body).to include("GLOW25")
    expect(response.body).not_to include("GLOW30")
  end

  it "falls back to the first live gift when the linked one is off or used up" do
    botox.update!(active: false)
    get "/promo/GLOW25"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("GLOW30")
    expect(response.body).not_to include("GLOW25")
  end

  it "shows the empty state when nothing is live" do
    botox.update!(active: false)
    boosters.update!(uses_count: 2)
    get "/promo"
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include("GLOW25")
    expect(response.body).not_to include("GLOW30")
    expect(response.body).to include("No gift is waiting today")
  end

  it "renders the Arabic page with Arabic copy and an RTL document" do
    get "/ar/promo"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('dir="rtl"')
    expect(response.body).to include("هدية من العناية")
    expect(response.body).to include("سكين بوسترز · خصم 30٪")
    expect(response.body).to include("احجزي توهجكِ الخاص")
    expect(response.body).to include(CGI.escape("أودّ حجز توهجي الخاص. الكود: GLOW30").gsub("+", "%20"))
  end

  describe "POST /promo/:code/claim" do
    it "counts one use per tap and reports what is left" do
      post "/promo/GLOW30/claim"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq("ok" => true, "remaining" => 1)
      expect(boosters.reload.uses_count).to eq(1)
    end

    it "accepts the code in any case" do
      post "/promo/glow25/claim"
      expect(response).to have_http_status(:ok)
      expect(botox.reload.uses_count).to eq(1)
    end

    it "refuses once the uses are spent" do
      2.times { post "/promo/GLOW30/claim" }
      post "/promo/GLOW30/claim"
      expect(response).to have_http_status(:conflict)
      expect(boosters.reload.uses_count).to eq(2)
    end

    it "404s an unknown code" do
      post "/promo/NOPE/claim"
      expect(response).to have_http_status(:not_found)
    end
  end
end
