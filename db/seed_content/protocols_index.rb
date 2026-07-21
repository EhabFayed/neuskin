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
        en: "Six protocols.", ar: "ستةُ بروتوكولات." },
      { key: "title_em", label: "Title line 2 (emphasis)",
        en: "One philosophy.", ar: "فلسفةٌ واحدة." },
      { key: "lead", label: "Lead paragraph", content_type: "richtext",
        en: "NeuSkin works through dedicated protocols, not à-la-carte treatments — these are sequenced plans with a clear start, a measured journey, and a review. Share your goals with us, and we will guide you to the right one.",
        ar: "في \"نيوسكن\"، نحن نعتمدُ على بروتوكولاتٍ مُخصصة لا مجرد علاجاتٍ متفرقة؛ فهي خططٌ مُرتّبة، تبدأُ بوضوح، وتمرُّ برحلةِ قياسٍ دقيقة، وتنتهي بمراجعةٍ للنتائج. أخبرينا بما تطمحين إليه، وسنرشدك إلى البروتوكول الأنسبِ لكِ." }
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
        en: "NeuSkin Method™", ar: "" },
      { key: "button", label: "Button label",
        en: "Begin with the NeuSkin Method™", ar: "" }
    ]
  }
])
