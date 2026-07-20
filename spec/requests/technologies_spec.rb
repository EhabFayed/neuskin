require "rails_helper"

RSpec.describe "Our Technologies page", type: :request do
  DEVICES = ["EMTONE", "EMFACE", "EMSCULPT", "POTENZA", "ELITE IQ", "REVLITE", "EMERALD"].freeze

  it "renders the English page with all seven device cards" do
    get "/en/technologies"
    expect(response).to have_http_status(:ok)
    DEVICES.each { |name| expect(response.body).to include(name) }
    expect(response.body).to include("Where Clinical Excellence")
    expect(response.body).to include("The Science of You")
    expect(response.body).to include("Technical specs")
  end

  it "renders the Arabic page with untranslated device names and the AR specs label" do
    get "/ar/technologies"
    expect(response).to have_http_status(:ok)
    DEVICES.each { |name| expect(response.body).to include(name) }
    expect(response.body).to include("المواصفات التقنية")
  end

  it "is linked from the header navigation" do
    get "/en"
    expect(response.body).to match(%r{href="(/en)?/technologies"})
  end
end
