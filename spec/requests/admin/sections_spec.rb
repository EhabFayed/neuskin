require "rails_helper"

RSpec.describe "Admin sections", type: :request do
  before { sign_in create(:user) }

  it "renders the edit form with content labels, not raw keys" do
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    create(:content, parentable: section, key: "headline",
           label: "Headline", value_en: "Old headline")
    get "/admin/sections/#{section.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Headline")     # friendly label
    expect(response.body).to include("Old headline")  # current value
  end

  it "updates a content value" do
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    content = create(:content, parentable: section, key: "headline",
                     label: "Headline", value_en: "Old")
    patch "/admin/sections/#{section.id}", params: {
      section: {
        label: "Hero",
        contents_attributes: {
          "0" => { id: content.id, key: "headline", label: "Headline",
                   value_en: "New headline", value_ar: content.value_ar,
                   content_type: "text", position: 0 }
        }
      }
    }
    expect(response).to redirect_to("/admin/sections/#{section.id}")
    expect(content.reload.value_en).to eq("New headline")
  end

  it "updates JSONB items from a JSON text field" do
    section = create(:section, page: "home", kind: "home_voices", label: "Voices")
    patch "/admin/sections/#{section.id}", params: {
      section: {
        items_json: '[{"q":{"en":"Great","ar":"رائع"},"by":{"en":"L.M.","ar":"ل.م."}}]'
      }
    }
    expect(section.reload.items).to eq(
      [{ "q" => { "en" => "Great", "ar" => "رائع" }, "by" => { "en" => "L.M.", "ar" => "ل.م." } }]
    )
  end
  it "re-renders with an error (no double-render) when items JSON is invalid" do
    section = create(:section, page: "home", kind: "home_voices", label: "Voices",
                     items: [{ "q" => { "en" => "orig" } }])
    patch "/admin/sections/#{section.id}", params: {
      section: { items_json: "{not valid json" }
    }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Items JSON is invalid.")
    expect(section.reload.items).to eq([{ "q" => { "en" => "orig" } }])
  end

  it "renders a live preview for every mapped page template" do
    Admin::SectionsController::PAGE_TEMPLATES.each_key do |page|
      section = Section.find_by(page: page) ||
                create(:section, page: page, kind: "#{page}_probe", label: "Probe")
      get "/admin/sections/#{section.id}/preview", params: { section: { label: section.label } }
      expect(response).to have_http_status(:ok), "preview for #{page} -> #{response.status}"
    end
  end
end
