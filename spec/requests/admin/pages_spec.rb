require "rails_helper"

RSpec.describe "Admin pages", type: :request do
  before { sign_in create(:user) }

  it "lists editable pages by friendly name" do
    get "/admin/pages"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Home")
    expect(response.body).to include("The Clinic")
  end

  it "shows a page's sections in order" do
    create(:section, page: "home", kind: "home_hero", label: "Hero", position: 0)
    create(:section, page: "home", kind: "home_promise", label: "The Promise", position: 1)
    get "/admin/pages/home"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Hero")
    expect(response.body).to include("The Promise")
  end
end
