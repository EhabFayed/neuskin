# robots.txt and sitemap.xml, rendered by the app rather than shipped as
# static files in public/.
#
# Why: static files go out with a one-year Cache-Control (see
# config.public_file_server.headers in config/environments/production.rb),
# and Cloudflare honours it — so after a deploy changed robots.txt, the edge
# kept serving the OLD file for a long time ("Cloudflare is changing our
# robots.txt"). These two responses carry a one-hour public cache instead, and
# the sitemap always reflects the live database (published journal posts,
# protocols, treatments, devices) in both languages with hreflang alternates —
# the hand-exported Screaming Frog file listed article URLs that no longer
# existed and cross-language slug duplicates.
class SeoController < ApplicationController
  # Public site pages, by route helper name — both languages of each go in.
  STATIC_ROUTES = %i[
    root the_clinic journal stories faq privacy medical_disclaimer terms
    the_team neuskin_method treatments technologies private_care protocols
    inquire bridal_concierge
  ].freeze

  def robots
    expires_in 1.hour, public: true
    render :robots, formats: :text, layout: false, content_type: "text/plain"
  end

  def sitemap
    expires_in 1.hour, public: true
    @entries = sitemap_entries
    render :sitemap, formats: :xml, layout: false
  end

  private

  # Each entry: { en: <absolute url>, ar: <absolute url>, lastmod: Time|nil }.
  def sitemap_entries
    entries = STATIC_ROUTES.map { |route| entry(route) }
    entries += Protocol.all.map  { |p| entry(:protocol, p, id: p.slug) }
    entries += Treatment.all.map { |t| entry(:treatment_outcome, t, outcome: t.slug) }
    entries += Device.all.map    { |d| entry(:technology, d, slug: d.slug) }
    entries += Blog.published.newest_first.map do |b|
      entry(:journal_article, b, en: { slug: b.slug_en }, ar: { slug: b.slug_ar.presence || b.slug_en })
    end
    entries
  end

  def entry(route, record = nil, en: {}, ar: {}, **params)
    {
      en:      absolute(public_send("#{route}_path", **params, **en, locale: nil)),
      ar:      absolute(public_send("#{route}_path", **params, **ar, locale: :ar)),
      lastmod: record&.updated_at
    }
  end

  def absolute(path)
    "#{helpers.seo_origin}#{path}"
  end
end
