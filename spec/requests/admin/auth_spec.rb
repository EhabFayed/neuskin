require "rails_helper"

RSpec.describe "Admin authentication", type: :request do
  it "redirects an unauthenticated visitor to sign in" do
    get "/admin"
    expect(response).to redirect_to("/users/sign_in")
  end
end
