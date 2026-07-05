require "rails_helper"

RSpec.describe "Admin dashboard", type: :request do
  it "shows counts to a signed-in user" do
    user = create(:user)
    sign_in user
    get "/admin"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Dashboard")
  end
end
