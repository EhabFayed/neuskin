require "rails_helper"

# Every Studio form that carries a file input must be multipart, or the
# browser posts the picked file as its filename (Active Storage then raises on
# the bogus signed id) and an untouched input arrives as "" — which Active
# Storage reads as "detach the current image". The shared image_field partial
# renders a raw <input type="file">, which does NOT flip form_with to
# multipart the way form.file_field does, so each form must say so itself.
RSpec.describe "Admin forms with file inputs", type: :request do
  let(:admin) { User.create!(email: "forms@neuskin.test", password: "changeme123", role: "admin") }

  before { sign_in admin }

  def file_forms
    Nokogiri::HTML(response.body).css("form").select { |f| f.at_css("input[type=file]") }
  end

  def expect_multipart(path)
    get path
    expect(response).to have_http_status(:ok), "#{path} -> #{response.status}"
    forms = file_forms
    expect(forms).not_to be_empty, "#{path}: no form with a file input rendered"
    forms.each do |form|
      expect(form["enctype"]).to eq("multipart/form-data"),
        "#{path}: form posting to #{form['action']} has a file input but enctype=#{form['enctype'].inspect}"
    end
  end

  %w[blogs protocols devices treatments stories team_members].each do |resource|
    it "posts /admin/#{resource} as multipart" do
      expect_multipart("/admin/#{resource}/new")
    end
  end

  it "posts the section editor as multipart" do
    section = Section.find_or_create_by!(page: "home", kind: "home_principles")
    expect_multipart("/admin/sections/#{section.id}")
  end
end
