# robots.txt and sitemap.xml — served verbatim from config/seo/.
#
# Both files are hand-maintained (the sitemap is a Screaming Frog export,
# Oct 2026); the app no longer builds them from the database. To change
# either, replace the file under config/seo/ and deploy.
#
# Why a controller and not public/: files in public/ go out with a one-year
# Cache-Control (config.public_file_server.headers in
# config/environments/production.rb) and Cloudflare honours it, so the edge
# kept serving an old robots.txt for months after a deploy. These two
# responses carry a one-hour public cache instead: a replaced file is live
# everywhere within the hour (purge the two URLs in Cloudflare to skip the
# wait). Do not add robots.txt / sitemap.xml to public/ — a file there wins
# over the route and brings the one-year header back.
class SeoController < ApplicationController
  SEO_DIR = Rails.root.join("config/seo")

  def robots
    serve "robots.txt", "text/plain"
  end

  def sitemap
    serve "sitemap.xml", "application/xml"
  end

  private

  def serve(filename, type)
    expires_in 1.hour, public: true
    send_file SEO_DIR.join(filename), type: type, disposition: :inline
  end
end
