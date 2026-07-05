# Home page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/home.html.erb (Task 11's sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("home", [
    {
      kind: "home_hero", label: "Hero — top of page", position: 0,
      contents: [
        { key: "eyebrow",    label: "Eyebrow (small line above headline)",
          en: "Doctor-led · Riyadh", ar: "" },
        { key: "headline_1", label: "Headline line 1",
          en: "Skin,", ar: "" },
        { key: "headline_2", label: "Headline line 2",
          en: "measured.", ar: "" },
        { key: "headline_3", label: "Headline line 3 (emphasis)",
          en: "Confidence, quiet.", ar: "" },
        { key: "sub",        label: "Sub-text under headline",
          en: "The doctor-led skin clinic for women in Riyadh — where every plan is read, written, and signed by Dr. Maysa.",
          ar: "" },
        { key: "foot_1",     label: "Footer note 1",
          en: "Est. Al Malqa · Riyadh", ar: "" },
        { key: "foot_2",     label: "Footer note 2",
          en: "Six protocols · one philosophy", ar: "" }
      ]
    },
    {
      kind: "home_principles", label: "Three principles", position: 1,
      contents: [
        { key: "eyebrow",   label: "Eyebrow",
          en: "The Promise", ar: "" },
        { key: "title",     label: "Heading",
          en: "Three commitments, quietly kept.", ar: "" },
        { key: "p1_num",    label: "Principle 1 — number/label",
          en: "01 — Principle", ar: "" },
        { key: "p1_title",  label: "Principle 1 — title",
          en: "Doctor-led", ar: "" },
        { key: "p1_body",   label: "Principle 1 — body",
          en: "Every plan is built by Dr. Maysa — never assembled from a treatment menu. One doctor, reading your skin and writing your year.",
          ar: "" },
        { key: "p2_num",    label: "Principle 2 — number/label",
          en: "02 — Principle", ar: "" },
        { key: "p2_title",  label: "Principle 2 — title",
          en: "Discreet", ar: "" },
        { key: "p2_body",   label: "Principle 2 — body",
          en: "Private consultation. Private treatment. Private results. A quiet room, a closed door, and nothing that leaves it.",
          ar: "" },
        { key: "p3_num",    label: "Principle 3 — number/label",
          en: "03 — Principle", ar: "" },
        { key: "p3_title",  label: "Principle 3 — title",
          en: "Measured", ar: "" },
        { key: "p3_body",   label: "Principle 3 — body",
          en: "Outcomes documented quarterly. No guesswork, no drama — only what the skin shows, recorded and reviewed.",
          ar: "" }
      ]
    },
    {
      kind: "home_founder", label: "Meet the founder", position: 2,
      contents: [
        { key: "eyebrow", label: "Eyebrow",
          en: "Meet the founder", ar: "" },
        { key: "body_1",  label: "Body paragraph 1",
          en: "I opened NeuSkin because I was tired of watching women sold ten treatments to fill a calendar. Skin is data — it can be read, and once read, it can be treated honestly.",
          ar: "" },
        { key: "body_2",  label: "Body paragraph 2",
          en: "Every patient here is met by one doctor, who builds one plan and reviews it every quarter. Nothing is rushed, and nothing is sold that isn't needed.",
          ar: "" },
        { key: "sign",    label: "Signature",
          en: "— Maysa", ar: "" },
        { key: "link",    label: "Link text",
          en: "Read her philosophy →", ar: "" }
      ]
    },
    {
      kind: "home_protocols", label: "Six protocols — heading", position: 3,
      contents: [
        { key: "eyebrow",  label: "Eyebrow",
          en: "The Six Protocols", ar: "" },
        { key: "title",    label: "Heading",
          en: "Six named protocols.", ar: "" },
        { key: "title_em", label: "Heading (emphasis)",
          en: "One philosophy. Zero menu pricing.", ar: "" },
        { key: "link",     label: "Link text",
          en: "View all protocols →", ar: "" }
      ]
    },
    {
      kind: "home_clinic", label: "Inside the clinic (hscroll)", position: 4,
      contents: [
        { key: "eyebrow",     label: "Eyebrow",
          en: "Inside NeuSkin", ar: "" },
        { key: "title",       label: "Heading",
          en: "The space,", ar: "" },
        { key: "title_em",    label: "Heading (emphasis)",
          en: "in passing.", ar: "" },
        { key: "lead",        label: "Lead paragraph",
          en: "A private clinic in Al Malqa — designed for quiet. Scroll on, and move through it.",
          ar: "" },
        { key: "cue",         label: "Scroll cue",
          en: "Scroll →", ar: "" },
        { key: "cap_1",       label: "Photo caption 1",
          en: "01 · Treatment room", ar: "" },
        { key: "cap_2",       label: "Photo caption 2",
          en: "02 · The lounge", ar: "" },
        { key: "cap_3",       label: "Photo caption 3",
          en: "03 · Device room", ar: "" },
        { key: "cap_4",       label: "Photo caption 4",
          en: "04 · In the detail", ar: "" },
        { key: "cap_5",       label: "Photo caption 5",
          en: "05 · The entrance", ar: "" },
        { key: "quote",       label: "Closing quote",
          en: "“A clinic should be measured by what it refuses to do.”", ar: "" },
        { key: "outro_link",  label: "Outro link text",
          en: "Tour the clinic →", ar: "" }
      ]
    },
    {
      kind: "home_quotes", label: "Testimonials", position: 5,
      contents: [
        { key: "eyebrow", label: "Eyebrow",
          en: "In their words", ar: "" },
        { key: "quote_1", label: "Quote 1 — text",
          en: "She told me what I didn't need before she told me what I did. I'd never had a doctor do that.",
          ar: "" },
        { key: "by_1",    label: "Quote 1 — attribution",
          en: "L.M. · Riyadh", ar: "" },
        { key: "quote_2", label: "Quote 2 — text",
          en: "Six months, one plan, reviewed every quarter. My skin looks like mine — only rested.",
          ar: "" },
        { key: "by_2",    label: "Quote 2 — attribution",
          en: "A.R. · Riyadh", ar: "" },
        { key: "quote_3", label: "Quote 3 — text",
          en: "Discreet from the first message to the last review. I never felt like a number on a calendar.",
          ar: "" },
        { key: "by_3",    label: "Quote 3 — attribution",
          en: "F.K. · Riyadh", ar: "" }
      ]
    },
    {
      kind: "home_cta", label: "Closing CTA band", position: 6,
      contents: [
        { key: "title",    label: "Heading",
          en: "There is no rush here.", ar: "" },
        { key: "title_em", label: "Heading (emphasis)",
          en: "Begin with a quiet conversation.", ar: "" },
        { key: "body",     label: "Body text",
          en: "A private message, reviewed personally by the clinic — Saturday to Thursday, 10:00–22:00.",
          ar: "" },
        { key: "cta",      label: "Button label",
          en: "Begin a private inquiry", ar: "" },
        { key: "sign",     label: "Signature",
          en: "— Dr. Maysa", ar: "" }
      ]
    }
  ])
