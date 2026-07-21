require "rails_helper"

RSpec.describe "Home page content", type: :system do
  it "renders the DB hero headline when a section provides it" do
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    create(:content, parentable: section, key: "headline_1",
           label: "Headline 1", value_en: "Measured beauty.", value_ar: "جمالٌ مقاس.")

    visit root_path(locale: "en")
    expect(page).to have_content("Measured beauty.")
  end

  it "falls back to the hardcoded literal when no section exists" do
    visit root_path(locale: "en")
    expect(page).to have_content(
      "Riyadh's doctor-led skin intelligence clinic. Where your aesthetic journey is guided by expert care, subtle results, and absolute privacy."
    )
  end
end
