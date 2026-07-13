require "rails_helper"

RSpec.describe "Admin account settings", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  it "shows the settings page with no delete-account affordance" do
    get "/admin/settings"
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to match(/delete\s+(my\s+)?account|remove\s+account|destroy\s+account/i)
  end

  it "updates the email with the correct current password" do
    patch "/admin/settings", params: { user: {
      email: "new@neuskin.test", current_password: user.password
    } }
    expect(user.reload.email).to eq("new@neuskin.test")
    expect(response).to redirect_to("/admin/settings")
  end

  it "changes the password and keeps the session alive" do
    patch "/admin/settings", params: { user: {
      email: user.email, password: "brandnew123", password_confirmation: "brandnew123",
      current_password: user.password
    } }
    expect(user.reload.valid_password?("brandnew123")).to be(true)
    follow_redirect!
    expect(response).to have_http_status(:ok) # still signed in
  end

  it "rejects updates with a wrong current password" do
    patch "/admin/settings", params: { user: {
      email: "hacker@evil.test", current_password: "wrong-password"
    } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(user.reload.email).not_to eq("hacker@evil.test")
  end

  it "exposes no route to destroy the account" do
    delete "/admin/settings"
    expect(response).to have_http_status(:not_found)
    # Devise registrations (which would add DELETE /users) are not mounted.
    registration_routes = Rails.application.routes.routes.select do |r|
      r.defaults[:controller].to_s.include?("registrations")
    end
    expect(registration_routes).to be_empty
  end
end
