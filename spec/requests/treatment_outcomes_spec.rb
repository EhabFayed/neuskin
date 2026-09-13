require "rails_helper"

RSpec.describe "Treatment outcome pages", type: :request do
  # Outcomes are Treatment records (dashboard-managed); the launch five are
  # recreated here with the protocol that owns each one.
  OUTCOMES = {
    "skin"        => "90-day-glow-reset",
    "hair"        => "reset-crown",
    "body"        => "8-week-sculpt",
    "injectables" => "neuskin-method",
    "devices"     => "neuskin-method"
  }.freeze

  before do
    %w[90-day-glow-reset reset-crown 8-week-sculpt neuskin-method].each do |slug|
      Protocol.find_or_create_by!(slug: slug) do |p|
        p.name_en = slug.titleize
        p.name_ar = slug
      end
    end
    OUTCOMES.each_with_index do |(slug, owner), i|
      Treatment.find_or_create_by!(slug: slug) do |t|
        t.title_en = slug.titleize
        t.headline_en = "#{slug.titleize} headline"
        t.protocol_slug = owner
        t.position = i
      end
    end
  end

  it "renders each outcome with its owning protocol" do
    OUTCOMES.each do |outcome, owner_slug|
      get "/en/treatments/#{outcome}"
      expect(response).to have_http_status(:ok), "expected /en/treatments/#{outcome} to render"
      expect(response.body).to include("The protocol that owns this")
      expect(response.body).to match(%r{href="(/en)?/protocols/#{owner_slug}"})
    end
  end

  it "links every outcome card on the treatments index to its sub-page" do
    get "/en/treatments"
    expect(response).to have_http_status(:ok)
    %w[skin hair body injectables devices].each do |outcome|
      expect(response.body).to match(%r{href="(/en)?/treatments/#{outcome}"})
    end
  end

  it "sends an unknown outcome home with a permanent redirect (no 404 pages)" do
    get "/en/treatments/unknown"
    expect(response).to have_http_status(:moved_permanently)
    expect(response).to redirect_to("/")
  end
end
