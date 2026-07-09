# Patient Stories page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/stories.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("stories", [
  {
    kind: "story_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "Patient Stories", ar: "" },
      { key: "title_1", label: "Title line 1",
        en: "Real women. Consented words.", ar: "" },
      { key: "title_em", label: "Title line 2 (emphasis)",
        en: "No stock photography.", ar: "" },
      { key: "lead", label: "Lead paragraph", content_type: "richtext",
        en: "Every story here is shared with explicit consent. Where a face is not shown, that too is a choice we respect.",
        ar: "" }
    ]
  },
  {
    kind: "story_items", label: "Story rows", position: 1,
    contents: [
      { key: "story_1_intro", label: "Story 1 intro",
        en: "She came in tired of being sold to. What she wanted was a plan.", ar: "" },
      { key: "story_1_quote", label: "Story 1 quote", content_type: "richtext",
        en: "For the first time, someone told me what not to do. That's when I trusted them.",
        ar: "" },
      { key: "story_1_protocol", label: "Story 1 protocol",
        en: "Diagnostic Foundation → Skin", ar: "" },
      { key: "story_1_close", label: "Story 1 closing line", content_type: "richtext",
        en: "Twelve months on, her routine is shorter and her skin is steadier than it has been in years.",
        ar: "" },
      { key: "story_1_by", label: "Story 1 attribution",
        en: "L.M. · 34 · Riyadh", ar: "" },

      { key: "story_2_intro", label: "Story 2 intro",
        en: "A bride with six months and a quiet kind of panic.", ar: "" },
      { key: "story_2_quote", label: "Story 2 quote", content_type: "richtext",
        en: "No one promised me a miracle. They promised me a calendar, and they kept it.",
        ar: "" },
      { key: "story_2_protocol", label: "Story 2 protocol",
        en: "The Bride's 180", ar: "" },
      { key: "story_2_close", label: "Story 2 closing line", content_type: "richtext",
        en: "She walked into her wedding without a single last-minute treatment — everything had been sequenced months earlier.",
        ar: "" },
      { key: "story_2_by", label: "Story 2 attribution",
        en: "A.R. · 29 · Jeddah", ar: "" },

      { key: "story_3_intro", label: "Story 3 intro",
        en: "Long-term maintenance, on her own terms.", ar: "" },
      { key: "story_3_quote", label: "Story 3 quote", content_type: "richtext",
        en: "I review my skin like I review anything that matters to me — with data, every quarter.",
        ar: "" },
      { key: "story_3_protocol", label: "Story 3 protocol",
        en: "Private Care", ar: "" },
      { key: "story_3_close", label: "Story 3 closing line", content_type: "richtext",
        en: "Three years in, the relationship is the treatment. Small adjustments, reviewed often, nothing overdone.",
        ar: "" },
      { key: "story_3_by", label: "Story 3 attribution",
        en: "F.K. · 41 · Riyadh", ar: "" }
    ]
  }
])
