# Per-page <title>, meta description and Open Graph tags.
#
# Every public page resolves its title/description in this order, so the
# dashboard controls them without a deploy and nothing ever falls back to
# the site-wide default by accident (that is what produced the "duplicate
# title / duplicate description" audit findings across the whole site):
#
#   1. content_for(:title) / content_for(:meta_description) — record pages
#      (journal article, protocol, treatment, device) set these from the
#      record's own meta fields (Admin → … → "Search preview").
#   2. The page's SEO section in the dashboard (Pages → <page> → "Search
#      preview (SEO)"): Content keys meta_title / meta_description, per language.
#   3. The built-in default for this page in config/locales (seo.<key>.*).
#   4. The site-wide default (layout.meta_title / layout.meta_description).
module SeoHelper
  # controller#action → the dashboard page + section that holds its SEO copy,
  # and the config/locales key for its built-in default.
  SEO_PAGES = {
    "pages#home"               => { cms: %w[home seo],                   key: "home" },
    "pages#the_clinic"         => { cms: %w[the_clinic seo],             key: "the_clinic" },
    "pages#neuskin_method"     => { cms: %w[maysa_method seo],           key: "neuskin_method" },
    "pages#the_team"           => { cms: %w[the_team seo],               key: "the_team" },
    "pages#treatments"         => { cms: %w[treatments seo],             key: "treatments" },
    "pages#technologies"       => { cms: %w[technologies seo],           key: "technologies" },
    "pages#private_care"       => { cms: %w[private_care seo],           key: "private_care" },
    "pages#stories"            => { cms: %w[stories seo],                key: "stories" },
    "pages#faq"                => { cms: %w[faq seo],                    key: "faq" },
    "pages#privacy"            => { cms: %w[legal seo_privacy],          key: "privacy" },
    "pages#medical_disclaimer" => { cms: %w[legal seo_medical_disclaimer], key: "medical_disclaimer" },
    "pages#terms"              => { cms: %w[legal seo_terms],            key: "terms" },
    "journal#index"            => { cms: %w[journal seo],                key: "journal" },
    "protocols#index"          => { cms: %w[protocols_index seo],        key: "protocols" },
    "inquiries#new"            => { cms: %w[inquire seo],                key: "inquire" },
    "inquiries#create"         => { cms: %w[inquire seo],                key: "inquire" },
    "bridal#show"              => { cms: %w[bridal seo],                 key: "bridal" },
    "bridal#checklist"         => { cms: %w[bridal seo],                 key: "bridal" }
  }.freeze

  # Longest description Google shows in full; anything longer is cut on a word.
  DESCRIPTION_LIMIT = 160

  def seo_title
    return content_for(:title) if content_for?(:title)

    seo_lookup("meta_title", "title").presence || t("layout.meta_title")
  end

  def seo_description
    text = content_for?(:meta_description) ? content_for(:meta_description) : seo_lookup("meta_description", "description")
    text = t("layout.meta_description") if text.blank?
    strip_tags(text.to_s).squish.truncate(DESCRIPTION_LIMIT, separator: " ")
  end

  # Open Graph type: "article" for journal posts (set via content_for), else website.
  def seo_og_type
    content_for?(:og_type) ? content_for(:og_type) : "website"
  end

  # Absolute share image: the page's own (content_for :og_image, e.g. an
  # article cover) or the clinic hero.
  def seo_image
    src = content_for?(:og_image) ? content_for(:og_image).to_s : image_path("site/hero-clinic.webp")
    src.start_with?("/") ? "#{seo_origin}#{src}" : src
  end

  def seo_og_locale(locale = I18n.locale)
    locale.to_sym == :ar ? "ar_SA" : "en_US"
  end

  private

  # Dashboard value for the current page, else its built-in default, else nil.
  def seo_lookup(cms_key, i18n_key)
    page = SEO_PAGES["#{controller_path}##{action_name}"]
    return if page.nil?

    cms_page, cms_kind = page[:cms]
    sec_text(cms_page, cms_kind, cms_key).presence ||
      I18n.t("seo.#{page[:key]}.#{i18n_key}", default: "").presence
  end
end
