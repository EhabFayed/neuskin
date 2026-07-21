# Private Care / VIP page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/private_care.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# HTML entities in the source (&middot;, &ldquo;, &rdquo;, &mdash;) are
# converted to their literal Unicode characters (· " " —) here, since
# `<%=` HTML-escapes plain string content — this matches the convention
# already used for curly quotes in db/seed_content/dr_maysa.rb.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("private_care", [
  {
    kind: "private_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow",  label: "Eyebrow",
        en: "Private Care · By invitation", ar: "" },
      { key: "title_1",  label: "Title line 1",
        en: "Private Care", ar: "" },
      { key: "title_2",  label: "Title line 2",
        en: "is by invitation.", ar: "" },
      { key: "title_em", label: "Title line 3 (emphasis)",
        en: "You may already qualify.", ar: "" },
      { key: "lead",     label: "Lead paragraph", content_type: "richtext",
        en: "A standing relationship with your doctor — arranged privately, kept discreetly, and offered only to those we invite.",
        ar: "" }
    ]
  },
  {
    kind: "private_includes", label: "What Private Care includes", position: 1,
    contents: [
      { key: "heading", label: "Section heading",
        en: "What Private Care includes", ar: "" },

      { key: "item_1", label: "Include item 1",
        en: "A standing relationship with your doctor, not a queue.", ar: "" },
      { key: "item_2", label: "Include item 2",
        en: "Same-week scheduling, including outside published hours.", ar: "" },
      { key: "item_3", label: "Include item 3",
        en: "Quarterly reviews with your full skin history in the room.", ar: "" },
      { key: "item_4", label: "Include item 4",
        en: "Discreet entry and a private suite for every visit.", ar: "" },
      { key: "item_5", label: "Include item 5",
        en: "Priority on new protocols before they are offered widely.", ar: "" },
      { key: "item_6", label: "Include item 6",
        en: "One point of contact who already knows your file.", ar: "" }
    ]
  },
  {
    kind: "private_tiers", label: "Membership tiers", position: 2,
    contents: [
      { key: "heading", label: "Section heading",
        en: "Membership tiers", ar: "" },

      { key: "tier_1_badge", label: "Tier 1 badge",
        en: "I", ar: "" },
      { key: "tier_1_name",  label: "Tier 1 name",
        en: "Quiet", ar: "" },
      { key: "tier_1_line",  label: "Tier 1 line",
        en: "The essential relationship.", ar: "" },
      { key: "tier_1_desc",  label: "Tier 1 description", content_type: "richtext",
        en: "Doctor-led care on your schedule, with quarterly reviews and a single private point of contact.",
        ar: "" },

      { key: "tier_2_badge", label: "Tier 2 badge",
        en: "II", ar: "" },
      { key: "tier_2_name",  label: "Tier 2 name",
        en: "Considered", ar: "" },
      { key: "tier_2_line",  label: "Tier 2 line",
        en: "For the long view.", ar: "" },
      { key: "tier_2_desc",  label: "Tier 2 description", content_type: "richtext",
        en: "Everything in Quiet, plus priority access to new protocols and an annual full reassessment.",
        ar: "" },

      { key: "tier_3_badge", label: "Tier 3 badge",
        en: "III", ar: "" },
      { key: "tier_3_name",  label: "Tier 3 name",
        en: "Invited", ar: "" },
      { key: "tier_3_line",  label: "Tier 3 line",
        en: "By our medical director, personally.", ar: "" },
      { key: "tier_3_desc",  label: "Tier 3 description", content_type: "richtext",
        en: "A bespoke relationship arranged case by case. Extended discretion, travel coordination, family care.",
        ar: "" }
    ]
  },
  {
    kind: "private_apply", label: "Application", position: 3,
    contents: [
      { key: "eyebrow",     label: "Eyebrow",
        en: "Application", ar: "" },
      { key: "quote",       label: "Quote", content_type: "richtext",
        en: "“Discretion is not a feature here. It is the entire promise — and I keep it personally.”",
        ar: "" },
      { key: "quote_cite",  label: "Quote citation",
        en: "— The NeuSkin Team", ar: "— فريق نيوسكن" },
      { key: "note",        label: "Note paragraph", content_type: "richtext",
        en: "Private Care has no public booking. Tell us a little, and if it is the right fit, we will reach out personally and privately.",
        ar: "" },

      { key: "field_name_label",     label: "Name field label",
        en: "Name", ar: "" },
      { key: "field_name_placeholder", label: "Name field placeholder",
        en: "Your name", ar: "" },

      { key: "field_contact_label",     label: "Contact field label",
        en: "Contact", ar: "" },
      { key: "field_contact_placeholder", label: "Contact field placeholder",
        en: "Mobile or email", ar: "" },

      { key: "field_referral_label",     label: "Referral source field label",
        en: "Referral source", ar: "" },
      { key: "field_referral_placeholder", label: "Referral source field placeholder",
        en: "How did you hear of us?", ar: "" },

      { key: "field_note_label",     label: "Brief note field label",
        en: "A brief note", ar: "" },
      { key: "field_note_placeholder", label: "Brief note field placeholder",
        en: "Anything you'd like us to know", ar: "" },

      { key: "submit_button", label: "Submit button text",
        en: "Submit application", ar: "" }
    ]
  }
])
