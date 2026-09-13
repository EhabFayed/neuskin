module JournalHelper
  # The rotating stock covers the Journal grid uses for posts without an
  # attached image.
  JOURNAL_FALLBACK_COVERS = [
    "site/journal/j1.webp",
    "site/journal/j2.webp",
    "site/journal/j3.webp"
  ].freeze

  # Cover for a Journal post — the attached image when present, else the SAME
  # rotating fallback its card gets on the grid, so the article page and its
  # card always match. (The content team may later give articles their own
  # inside image — that's just an attachment away; this is the interim rule.)
  # `position` is the post's index in the grid when the caller already knows
  # it; otherwise it is derived from the published ordering.
  def journal_cover_source(blog, position: nil, width: 900)
    return opt_url(blog.image, width: width) if blog.image.attached?

    position ||= Blog.published.newest_first.pluck(:id).index(blog.id) || 0
    JOURNAL_FALLBACK_COVERS[position % JOURNAL_FALLBACK_COVERS.size]
  end
end
