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

    # One URL per language: the English slug under /journal, the Arabic slug
    # under /ar/journal. Either slug still resolves (old links, the language
    # switch), but any other combination 301s to the right one, so the same
    # article is never indexed under a foreign-language slug.
    canonical_slug = @blog.to_param
    if params[:slug] != canonical_slug
      redirect_to journal_article_path(canonical_slug), status: :moved_permanently
      return
    end

    localize_route_params en: { slug: @blog.slug_en },
                          ar: { slug: @blog.slug_ar.presence || @blog.slug_en }
  end
end
