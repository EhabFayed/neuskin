require "rails_helper"

RSpec.describe "Editing the home page from admin", type: :system do
  it "changes the live home headline" do
    admin   = create(:admin_user)
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    create(:content, parentable: section, key: "headline_1", label: "Headline line 1",
           value_en: "Original headline", value_ar: "العنوان")

    sign_in admin

    visit admin_section_path(section)
    expect(page).to have_content("Headline line 1")
    expect(page).to have_field(name: "section[contents_attributes][0][value_en]", with: "Original headline")

    fill_in name: "section[contents_attributes][0][value_en]", with: "Brand new headline"
    click_button "Save"
    expect(page).to have_content("Saved.")

    visit root_path(locale: "en")
    expect(page).to have_content("Brand new headline")
  end
end
