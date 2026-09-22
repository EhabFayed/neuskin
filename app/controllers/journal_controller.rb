# Public Journal — published posts only, newest first.
class JournalController < ApplicationController
  def index
    @blogs = Blog.published.newest_first.with_attached_image.with_attached_image_ar.includes(:contents)
  end

  def show
    # find_by_any_slug! runs inside the published scope, so drafts 404.
    @blog = Blog.published
                .includes(contents: [ { photo_attachment: :blob }, { photo_ar_attachment: :blob } ])
                .find_by_any_slug!(params[:slug])
  end
end
