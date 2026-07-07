require "rails_helper"

RSpec.describe "Treatment outcome pages", type: :request do
  before do
    %w[90-day-glow-reset reset-crown 8-week-sculpt maysa-method].each do |slug|
      Protocol.find_or_create_by!(slug: slug) do |p|
        p.name_en = slug.titleize
        p.name_ar = slug
      end
    end
  end

  it "renders each outcome with its owning protocol" do
    {
      "skin"        => "90-day-glow-reset",
      "hair"        => "reset-crown",
      "body"        => "8-week-sculpt",
      "injectables" => "maysa-method",
      "devices"     => "maysa-method"
    }.each do |outcome, owner_slug|
      get "/en/treatments/#{outcome}"
      expect(response).to have_http_status(:ok), "expected /en/treatments/#{outcome} to render"
      expect(response.body).to include("The protocol that owns this")
      expect(response.body).to match(%r{href="(/en)?/protocols/#{owner_slug}"})
    end
  end

  it "does not route an unknown outcome" do
    expect {
      Rails.application.routes.recognize_path("/en/treatments/unknown", method: :get)
    }.to raise_error(ActionController::RoutingError)
  end
end
