# Legal & Compliance page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/legal.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# HTML entities in the original markup (&amp;, &mdash;, &rsquo;) are
# converted to literal Unicode characters here so `<%=` escaping renders
# them correctly without double-encoding.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("legal", [
  {
    kind: "legal_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "Legal & Compliance", ar: "" },
      { key: "title_1", label: "Title",
        en: "Plainly stated.", ar: "" },
      { key: "lead", label: "Lead paragraph", content_type: "richtext",
        en: "We keep our terms in human language. This is a demonstration page — final legal copy is prepared with counsel for KSA / PDPL compliance.",
        ar: "" }
    ]
  },
  {
    kind: "legal_blocks", label: "Legal sections", position: 1,
    contents: [
      { key: "privacy_title", label: "Privacy block heading",
        en: "Privacy & PDPL", ar: "" },
      { key: "privacy_p1", label: "Privacy block paragraph 1", content_type: "richtext",
        en: "We collect only what we need to care for you and to reply to your inquiry. Your personal data is stored securely, used solely for your care and communication with you, and never sold or shared for marketing.",
        ar: "" },
      { key: "privacy_p2", label: "Privacy block paragraph 2", content_type: "richtext",
        en: "You may ask to see, correct, or delete the information we hold at any time. Our handling of personal data follows Saudi Arabia’s Personal Data Protection Law (PDPL).",
        ar: "" },

      { key: "medical_title", label: "Medical disclaimer heading",
        en: "Medical advertising disclaimer", ar: "" },
      { key: "medical_p1", label: "Medical disclaimer paragraph 1", content_type: "richtext",
        en: "Results vary from person to person and depend on individual factors. Every treatment is subject to medical consultation and individual assessment, and no specific outcome is guaranteed.",
        ar: "" },
      { key: "medical_p2", label: "Medical disclaimer paragraph 2", content_type: "richtext",
        en: "Nothing on this site is medical advice or a substitute for an in-person consultation with a licensed practitioner.",
        ar: "" },

      { key: "consent_title", label: "Consent policy heading",
        en: "Consent policy", ar: "" },
      { key: "consent_p1", label: "Consent policy paragraph", content_type: "richtext",
        en: "Photography and the use of any patient material require separate, specific, written consent. Consent is never assumed, is given freely, and may be withdrawn at any time without affecting your care.",
        ar: "" },

      { key: "terms_title", label: "Terms of inquiry heading",
        en: "Terms of inquiry", ar: "" },
      { key: "terms_p1", label: "Terms of inquiry paragraph 1", content_type: "richtext",
        en: "Submitting an inquiry begins a private conversation, not a booking or a contract. All care is arranged after a medical consultation and individual assessment.",
        ar: "" },
      { key: "terms_p2", label: "Terms of inquiry paragraph 2", content_type: "richtext",
        en: "We reply personally, Saturday to Thursday. By contacting us you agree only to be contacted back — nothing more.",
        ar: "" }
    ]
  },
  {
    kind: "legal_license", label: "License line", position: 2,
    contents: [
      { key: "label", label: "License label",
        en: "SFDA / MOH license", ar: "" },
      { key: "number", label: "License number",
        en: "No. 0000000000", ar: "" }
    ]
  }
])
