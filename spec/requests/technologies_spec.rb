require "rails_helper"

RSpec.describe "Our Technologies page", type: :request do
  before do
    Device.create!(name: "EMTONE", position: 1,
                   tagline_en: "Harmonious Rejuvenation", tagline_ar: "نضارة متناغمة",
                   body_en: "Front copy.", specs_en: "Back specs.")
    Device.create!(name: "EMERALD", position: 2,
                   tagline_en: "Natural Fat Loss", tagline_ar: "فقدان الدهون الطبيعي",
                   body_en: "Front copy.", specs_en: "Back specs.")
  end

  it "renders the English page with a card per device record" do
    get "/en/technologies"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("EMTONE")
    expect(response.body).to include("EMERALD")
    expect(response.body).to include("Harmonious Rejuvenation")
    expect(response.body).to include("Where Clinical Excellence")
    expect(response.body).to include("The Science of You")
    expect(response.body).to include("Technical specs")
  end

  it "renders the Arabic page with untranslated device names, AR taglines and the AR specs label" do
    get "/ar/technologies"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("EMTONE")
    expect(response.body).to include("نضارة متناغمة")
    expect(response.body).to include("المواصفات التقنية")
  end

  it "renders without a device grid when no devices exist" do
    Device.delete_all
    get "/en/technologies"
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include("tech-grid")
  end

  it "is linked from the header navigation" do
    get "/en"
    expect(response.body).to match(%r{href="(/en)?/technologies"})
  end
end
