require "rails_helper"

RSpec.describe "Admin RTE image uploads", type: :request do
  let(:png) { Rails.root.join("spec/fixtures/files/pixel.png") }

  it "requires a signed-in editor" do
    post "/admin/uploads", params: { file: Rack::Test::UploadedFile.new(png, "image/png") }
    expect(response).to redirect_to("/users/sign_in")
  end

  context "signed in" do
    before { sign_in create(:user) }

    it "stores an image and returns its proxy URL as JSON" do
      expect {
        post "/admin/uploads", params: { file: Rack::Test::UploadedFile.new(png, "image/png") }
      }.to change(ActiveStorage::Blob, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.media_type).to eq("application/json")
      url = response.parsed_body["url"]
      expect(url).to start_with("/rails/active_storage/blobs/proxy/")
      expect(url).to end_with("/pixel.png")

      # the URL is a permanent path (no expiring signed disk URL) that serves the file
      get url
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to start_with("image/png")
    end

    it "rejects a non-image with 422 JSON" do
      text = Tempfile.new([ "notes", ".txt" ]).tap { |f| f.write("hello"); f.rewind }
      expect {
        post "/admin/uploads", params: { file: Rack::Test::UploadedFile.new(text.path, "text/plain") }
      }.not_to change(ActiveStorage::Blob, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["error"]).to be_present
    end

    it "rejects a missing file with 422 JSON" do
      post "/admin/uploads", params: {}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["error"]).to be_present
    end

    it "rejects an oversized image with 422 JSON" do
      stub_const("Admin::UploadsController::MAX_BYTES", 10)
      post "/admin/uploads", params: { file: Rack::Test::UploadedFile.new(png, "image/png") }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["error"]).to include("10 MB")
    end
  end
end
