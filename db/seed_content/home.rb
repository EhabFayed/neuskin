# Home page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/home.html.erb (Task 11's sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
module SeedContent
  HOME = [
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
      kind: "home_founder", label: "Meet the founder", position: 1,
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
    }
  ].freeze
end
