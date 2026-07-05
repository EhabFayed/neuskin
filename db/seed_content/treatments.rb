# Treatments (by outcome) page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/treatments.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Note: each outcome's image symbol, persona, and codeword drive routing/
# asset lookup (not display copy), so they remain Ruby-side data and are not
# exposed as editable text fields.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("treatments", [
  {
    kind: "treatments_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow",  label: "Eyebrow",
        en: "Treatments · by outcome", ar: "" },
      { key: "title_1",  label: "Title part 1 (before emphasis)",
        en: "We don't treat machines.", ar: "" },
      { key: "title_em", label: "Title emphasis span",
        en: "We treat outcomes.", ar: "" },
      { key: "lead",     label: "Lead paragraph", content_type: "richtext",
        en: "Searching for a specific treatment? Start with what you actually want changed. We'll show you how we approach it — and which protocol it belongs to.",
        ar: "" }
    ]
  },
  {
    kind: "treatments_outcomes", label: "Outcomes grid", position: 1,
    contents: [
      { key: "outcome_1_title",    label: "Outcome 1 tag",
        en: "Tired, dull skin", ar: "" },
      { key: "outcome_1_headline", label: "Outcome 1 headline",
        en: "Skin that looks rested, not redone.", ar: "" },

      { key: "outcome_2_title",    label: "Outcome 2 tag",
        en: "Hair & shedding", ar: "" },
      { key: "outcome_2_headline", label: "Outcome 2 headline",
        en: "Density, returned quietly.", ar: "" },

      { key: "outcome_3_title",    label: "Outcome 3 tag",
        en: "Body, tone & contour", ar: "" },
      { key: "outcome_3_headline", label: "Outcome 3 headline",
        en: "Definition that reads as discipline.", ar: "" },

      { key: "outcome_4_title",    label: "Outcome 4 tag",
        en: "A wedding ahead", ar: "" },
      { key: "outcome_4_headline", label: "Outcome 4 headline",
        en: "Six months, planned to the day.", ar: "" },

      { key: "outcome_5_title",    label: "Outcome 5 tag",
        en: "Long-term maintenance", ar: "" },
      { key: "outcome_5_headline", label: "Outcome 5 headline",
        en: "A year, kept on quiet review.", ar: "" },

      { key: "outcome_6_title",    label: "Outcome 6 tag",
        en: "Not sure yet", ar: "" },
      { key: "outcome_6_headline", label: "Outcome 6 headline",
        en: "Start by reading the skin.", ar: "" }
    ]
  },
  {
    kind: "treatments_footer", label: "Footer link", position: 2,
    contents: [
      { key: "protocols_link", label: "\"View all protocols\" link text",
        en: "View all six protocols →", ar: "" }
    ]
  }
])
