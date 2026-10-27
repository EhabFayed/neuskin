require "rails_helper"

RSpec.describe "Admin promos", type: :request do
  let(:admin) { User.create!(email: "promo@neuskin.test", password: "changeme123", role: "admin") }
  let(:valid) do
    { label_en: "SKIN BOOSTERS", percent: 30, code: "glow30", title_en: "Skin boosters, 30% off",
      description_en: "Deep hydration.", max_uses: 50, position: 1, active: "1" }
  end

  before { sign_in admin }

  it "lists promos with their code, uses and status" do
    Promo.create!(valid.merge(uses_count: 7))
    get admin_promos_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("GLOW30")
    expect(response.body).to include("7 / 50")
    expect(response.body).to include("Live")
  end

  it "shows the gift's own share link on the edit page" do
    promo = Promo.create!(valid)
    get edit_admin_promo_path(promo)
    expect(response.body).to include("/promo/GLOW30")
  end

  it "shows the Promos item in the sidebar" do
    get admin_root_path
    expect(response.body).to include("Promos")
    expect(response.body).to include(admin_promos_path)
  end

  it "creates a promo from the form" do
    expect { post admin_promos_path, params: { promo: valid } }.to change(Promo, :count).by(1)
    promo = Promo.last
    expect(promo.code).to eq("GLOW30")
    expect(promo.max_uses).to eq(50)
    expect(promo).to be_active
    expect(response).to redirect_to(admin_promos_path)
  end

  it "re-renders the form with errors on bad input" do
    post admin_promos_path, params: { promo: valid.merge(percent: 0, code: "") }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Percent must be greater than 0")
    expect(response.body).to include("Code can&#39;t be blank")
  end

  it "updates the limit, resets the count and switches a promo off" do
    promo = Promo.create!(valid.merge(uses_count: 12))
    patch admin_promo_path(promo), params: { promo: { max_uses: "", uses_count: 0, active: "0" } }
    promo.reload
    expect(promo.max_uses).to be_nil
    expect(promo.uses_count).to eq(0)
    expect(promo).not_to be_active
  end

  it "deletes a promo" do
    promo = Promo.create!(valid)
    expect { delete admin_promo_path(promo) }.to change(Promo, :count).by(-1)
  end

  it "requires sign-in" do
    sign_out admin
    get admin_promos_path
    expect(response).to redirect_to(new_user_session_path)
  end
end
