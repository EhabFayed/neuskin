# Protocols hub page chrome content seed.
#
# The Protocol RECORDS themselves are DB-backed (see db/seeds.rb / Protocol
# model) and are NOT covered here — only the static page chrome (hero,
# filter eyebrow, closing CTA) is migrated to CMS-editable content.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/protocols/index.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("protocols_index", [
  {
    kind: "protocols_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The Protocols", ar: "" },
      { key: "title_1", label: "Title line 1",
        en: "Six named protocols.", ar: "" },
      { key: "title_em", label: "Title line 2 (emphasis)",
        en: "One philosophy. Zero menu pricing.", ar: "" },
      { key: "lead", label: "Lead paragraph", content_type: "richtext",
        en: "NeuSkin works in protocols, not à-la-carte treatments — sequenced plans with a beginning, a measured middle, and a review built in. Six named programmes, one philosophy, and never a price list.",
        ar: "" }
    ]
  },
  {
    kind: "protocols_filter", label: "Persona filter", position: 1,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "I'm here because…", ar: "" }
    ]
  },
  {
    kind: "protocols_cta", label: "Closing CTA", position: 2,
    contents: [
      { key: "kicker", label: "Kicker line",
        en: "Not sure where to start?", ar: "" },
      { key: "title", label: "Title (before emphasis)",
        en: "Begin with the", ar: "" },
      { key: "title_em", label: "Title (emphasis)",
        en: "Maysa Method™", ar: "" },
      { key: "button", label: "Button label",
        en: "Begin with the Maysa Method™", ar: "" }
    ]
  }
])
