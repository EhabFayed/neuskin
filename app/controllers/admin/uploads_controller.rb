module Admin
  # Inline image uploads from the Studio rich-text editor (Quill). The editor
  # POSTs the picked file here and embeds the returned URL, so the article
  # HTML carries a permanent ActiveStorage proxy URL instead of a base64
  # data: URI (which the public sanitizer strips).
  class UploadsController < BaseController
    MAX_BYTES = 10.megabytes

    def create
      file = params[:file]
      return invalid("No file received.") unless file.respond_to?(:original_filename)
      return invalid("Only image files can be inserted.") unless file.content_type.to_s.start_with?("image/")
      return invalid("Image is larger than 10 MB.") if file.size.to_i > MAX_BYTES

      blob = ActiveStorage::Blob.create_and_upload!(
        io: file, filename: file.original_filename, content_type: file.content_type
      )
      render json: { url: rails_storage_proxy_path(blob) }, status: :created
    end

    private

    def invalid(message)
      render json: { error: message }, status: :unprocessable_entity
    end
  end
end
