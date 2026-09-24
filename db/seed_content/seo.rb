# "Search preview (SEO)" section for every dashboard page: the <title> and
# meta description Google shows for that page, per language.
#
# Values are seeded BLANK on purpose — blank means "use the built-in default
# for this page" (config/locales en.yml / ar.yml under `seo:`), so editors only
# fill these in when they want to override the default. Resolution order is
# documented in app/helpers/seo_helper.rb.
#
# The three legal documents share the "legal" dashboard page, so they get one
# section each (seo_privacy / seo_medical_disclaimer / seo_terms).
#
# Idempotent: upserts by (page, kind) and (section, key). No constants or
# top-level methods here — this file is `load`ed, possibly more than once.
require_relative "_registry"

hint_title = "Shown as the clickable headline in Google and in link previews. " \
             "Leave blank to use the built-in default. Under 60 characters is safest."
hint_desc  = "The one or two sentences shown under the headline in Google. " \
             "Leave blank to use the built-in default. Under 160 characters."

seo_section = lambda do |kind: "seo", label: "Search preview (SEO)"|
  {
    kind: kind, label: label, position: 99,
    contents: [
      { key: "meta_title",       label: "Meta title",       hint: hint_title, en: "", ar: "" },
      { key: "meta_description", label: "Meta description", hint: hint_desc,  en: "", ar: "" }
    ]
  }
end

%w[home the_clinic maysa_method the_team treatments technologies private_care
   journal stories faq protocols_index bridal inquire].each do |page|
  SeedContent.register(page, [ seo_section.call ])
end

SeedContent.register("legal", [
  seo_section.call(kind: "seo_privacy",            label: "Search preview (SEO) — Privacy"),
  seo_section.call(kind: "seo_medical_disclaimer", label: "Search preview (SEO) — Medical disclaimer"),
  seo_section.call(kind: "seo_terms",              label: "Search preview (SEO) — Terms")
])
