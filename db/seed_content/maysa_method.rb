# The Maysa Method page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/maysa_method.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("maysa_method", [
  {
    kind: "method_hero", label: "Hero — stacked eyebrow/sub/main", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The Philosophy", ar: "" },
      { key: "sub",     label: "Subheading (h2)",
        en: "Skin is data.", ar: "" },
      { key: "main",    label: "Main heading (h1)",
        en: "Read it, then treat it.", ar: "" }
    ]
  },
  {
    kind: "method_principle", label: "The principle", position: 1,
    contents: [
      { key: "title", label: "Title",
        en: "The principle", ar: "" },
      { key: "lead",  label: "Lead paragraph", content_type: "richtext",
        en: "The Maysa Method™ is not a treatment. It is a way of deciding. Before anything is recommended, we read the skin, hair and body as a single connected system and let that reading — not a menu — decide what comes next.",
        ar: "" }
    ]
  },
  {
    kind: "method_pillars", label: "Four pillars", position: 2,
    contents: [
      { key: "pillar_1_num",   label: "Pillar 1 number",
        en: "Pillar 01", ar: "" },
      { key: "pillar_1_title", label: "Pillar 1 title",
        en: "Skin", ar: "" },
      { key: "pillar_1_body",  label: "Pillar 1 body",
        en: "Barrier, tone, texture and pigment — read, then restored in order.", ar: "" },
      { key: "pillar_2_num",   label: "Pillar 2 number",
        en: "Pillar 02", ar: "" },
      { key: "pillar_2_title", label: "Pillar 2 title",
        en: "Hair", ar: "" },
      { key: "pillar_2_body",  label: "Pillar 2 body",
        en: "Scalp health and density, assessed clinically and supported over weeks.", ar: "" },
      { key: "pillar_3_num",   label: "Pillar 3 number",
        en: "Pillar 03", ar: "" },
      { key: "pillar_3_title", label: "Pillar 3 title",
        en: "Body", ar: "" },
      { key: "pillar_3_body",  label: "Pillar 3 body",
        en: "Tone, contour and posture — measured, not guessed, and supported clinically.", ar: "" },
      { key: "pillar_4_num",   label: "Pillar 4 number",
        en: "Pillar 04", ar: "" },
      { key: "pillar_4_title", label: "Pillar 4 title",
        en: "Lifestyle", ar: "" },
      { key: "pillar_4_body",  label: "Pillar 4 body",
        en: "Sleep, sun, stress and habit — the quiet inputs that decide how the rest holds.", ar: "" }
    ]
  },
  {
    kind: "method_not", label: "What it is not", position: 3,
    contents: [
      { key: "eyebrow",     label: "Eyebrow",
        en: "What it is not", ar: "" },
      { key: "title_1",     label: "Title part 1 (before emphasis)",
        en: "Discipline is mostly", ar: "" },
      { key: "title_em",    label: "Title emphasis span",
        en: "restraint.", ar: "" },
      { key: "item_1",      label: "Exclusion item 1",
        en: "It is not a treatment, and nothing is performed during it.", ar: "" },
      { key: "item_2",      label: "Exclusion item 2",
        en: "It is not a quick fix; good skin is sequenced over time.", ar: "" },
      { key: "item_3",      label: "Exclusion item 3",
        en: "It is not a price list, and it is never sold from a menu.", ar: "" },
      { key: "item_4",      label: "Exclusion item 4",
        en: "It is not for everyone — and that is entirely intentional.", ar: "" }
    ]
  },
  {
    kind: "method_timeline", label: "A year, in four movements — horizontal scroller", position: 4,
    contents: [
      { key: "eyebrow",       label: "Eyebrow",
        en: "The 12-month timeline", ar: "" },
      { key: "title_1",       label: "Title part 1 (before emphasis)",
        en: "A year, in", ar: "" },
      { key: "title_em",      label: "Title emphasis span",
        en: "four movements.", ar: "" },
      { key: "intro_body",    label: "Intro paragraph",
        en: "The Maysa Method™ unfolds over four quarters — measured, reviewed, adjusted. Scroll through the year.", ar: "" },
      { key: "cue",           label: "Scroll cue",
        en: "Scroll →", ar: "" },
      { key: "panel_1_q",     label: "Panel 1 quarter label",
        en: "Q1", ar: "" },
      { key: "panel_1_title", label: "Panel 1 title",
        en: "Diagnose", ar: "" },
      { key: "panel_1_body",  label: "Panel 1 body",
        en: "Baseline captured, the plan written. The slow, invisible work begins.", ar: "" },
      { key: "panel_2_q",     label: "Panel 2 quarter label",
        en: "Q2", ar: "" },
      { key: "panel_2_title", label: "Panel 2 title",
        en: "Restore", ar: "" },
      { key: "panel_2_body",  label: "Panel 2 body",
        en: "Targeted correction across the four pillars, reviewed against baseline.", ar: "" },
      { key: "panel_3_q",     label: "Panel 3 quarter label",
        en: "Q3", ar: "" },
      { key: "panel_3_title", label: "Panel 3 title",
        en: "Build", ar: "" },
      { key: "panel_3_body",  label: "Panel 3 body",
        en: "Results compounded; the plan adjusted to how your skin responded.", ar: "" },
      { key: "panel_4_q",     label: "Panel 4 quarter label",
        en: "Q4", ar: "" },
      { key: "panel_4_title", label: "Panel 4 title",
        en: "Maintain", ar: "" },
      { key: "panel_4_body",  label: "Panel 4 body",
        en: "A maintenance rhythm set, and a record you keep for the years ahead.", ar: "" },
      { key: "quote",         label: "Closing quote (outro)",
        en: "“Skin is data. Read it across a year, and it stops surprising you.”", ar: "" },
      { key: "cta_label",     label: "Outro CTA button label",
        en: "Request the Assessment", ar: "" }
    ]
  },
  {
    kind: "method_cta", label: "Closing CTA", position: 5,
    contents: [
      { key: "title_1",   label: "Title part 1 (before emphasis)",
        en: "Begin with the", ar: "" },
      { key: "title_em",  label: "Title emphasis span",
        en: "Maysa Method™.", ar: "" },
      { key: "body",      label: "Body text",
        en: "One reading, one written plan, reviewed every quarter. It begins with a private inquiry.", ar: "" },
      { key: "cta_label", label: "CTA button label",
        en: "Request the Assessment", ar: "" }
    ]
  }
])
