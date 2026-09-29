require "rails_helper"

# Devices route by slug (Device#to_param), so the admin must look them up by
# slug too — a numeric-id lookup 404s every edit/update/delete link.
RSpec.describe "Admin devices", type: :request do
  let(:admin)  { User.create!(email: "dev@neuskin.test", password: "changeme123", role: "admin") }
  let(:device) { Device.create!(name: "Emtone") }

  before { sign_in admin }

  it "opens the edit page from the slug link the index renders" do
    get edit_admin_device_path(device)
    expect(response.request.path).to eq("/admin/devices/emtone/edit")
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Search preview (SEO)")
  end

  it "updates a device through its slug" do
    patch admin_device_path(device), params: { device: { name: "Emtone", meta_title_en: "Emtone in Riyadh" } }
    expect(device.reload.meta_title_en).to eq("Emtone in Riyadh")
  end

  it "deletes a device through its slug" do
    delete admin_device_path(device)
    expect(Device.exists?(device.id)).to be(false)
  end
end
