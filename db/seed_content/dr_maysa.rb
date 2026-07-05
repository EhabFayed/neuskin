# Dr. Maysa page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/dr_maysa.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("dr_maysa", [
  {
    kind: "drmaysa_hero", label: "Hero — portrait + quote", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The Founder · Medical Director", ar: "" },
      { key: "quote",   label: "Hero quote (headline)",
        en: "“I would rather treat one thing well than ten things to fill a calendar.”", ar: "" },
      { key: "sign",    label: "Signature",
        en: "— Dr. Maysa Al-Rashid", ar: "" }
    ]
  },
  {
    kind: "drmaysa_creds", label: "Credentials band", position: 1,
    contents: [
      { key: "cred_1", label: "Credential line 1",
        en: "MBBS · Dermatology", ar: "" },
      { key: "cred_2", label: "Credential line 2",
        en: "Aesthetic Medicine Fellowship", ar: "" },
      { key: "cred_3", label: "Credential line 3",
        en: "Regenerative Aesthetics", ar: "" },
      { key: "cred_4", label: "Credential line 4",
        en: "SFDA / MOH Licensed", ar: "" },
      { key: "cred_5", label: "Credential line 5",
        en: "Member · Saudi Society of Dermatology", ar: "" }
    ]
  },
  {
    kind: "drmaysa_philosophy", label: "How I think about treatment", position: 2,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "How I think about treatment", ar: "" },
      { key: "body_1",  label: "Body paragraph 1", content_type: "richtext",
        en: "I trained in dermatology expecting to spend my life treating disease. What I found, in practice, was something quieter and more interesting — women who did not need fixing, only reading. The face in front of me was rarely the problem. The plan around it usually was.",
        ar: "" },
      { key: "pull_1",  label: "Pull quote 1",
        en: "“Skin is data. My job is to read it before anyone touches it.”", ar: "" },
      { key: "body_2",  label: "Body paragraph 2", content_type: "richtext",
        en: "So I built NeuSkin around the assessment, not the treatment. Every patient begins by being read — skin, hair, body — as a baseline, and only then is anything proposed. The plan is written down, sequenced, and reviewed every quarter against where we began.",
        ar: "" },
      { key: "body_3",  label: "Body paragraph 3", content_type: "richtext",
        en: "There are things I will not do. I will not chase a trend onto a healthy face. I will not perform a procedure a patient does not understand. And I will not sell a year of sessions when three honest months would do.",
        ar: "" },
      { key: "pull_2",  label: "Pull quote 2",
        en: "“The best result I can give you is the one no one can name.”", ar: "" },
      { key: "body_4",  label: "Body paragraph 4", content_type: "richtext",
        en: "What I insist on is measurement. We document where you begin and we compare honestly as we go, so progress is never left to memory or to flattery. That is the whole method, and it is the only promise I make.",
        ar: "" },
      { key: "sign",    label: "Signature",
        en: "— Maysa", ar: "" }
    ]
  },
  {
    kind: "drmaysa_method", label: "The Maysa Method™ — three steps", position: 3,
    contents: [
      { key: "eyebrow",      label: "Eyebrow",
        en: "The Maysa Method™", ar: "" },
      { key: "title",        label: "Section title",
        en: "Three steps. One connected system.", ar: "" },
      { key: "step_1_n",     label: "Step 1 number",
        en: "01", ar: "" },
      { key: "step_1_title", label: "Step 1 title",
        en: "Diagnostic mapping", ar: "" },
      { key: "step_1_body",  label: "Step 1 body",
        en: "Skin, hair and body baseline — captured with imaging and a doctor-led examination.", ar: "" },
      { key: "step_2_n",     label: "Step 2 number",
        en: "02", ar: "" },
      { key: "step_2_title", label: "Step 2 title",
        en: "The 12-month plan", ar: "" },
      { key: "step_2_body",  label: "Step 2 body",
        en: "A written roadmap across skin, hair, body and lifestyle — yours to keep.", ar: "" },
      { key: "step_3_n",     label: "Step 3 number",
        en: "03", ar: "" },
      { key: "step_3_title", label: "Step 3 title",
        en: "Quarterly review", ar: "" },
      { key: "step_3_body",  label: "Step 3 body",
        en: "We measure, compare and adjust as your skin responds over time.", ar: "" },
      { key: "cta_label",    label: "CTA button label",
        en: "Request the Maysa Method™ Assessment", ar: "" }
    ]
  },
  {
    kind: "drmaysa_clips", label: "In her words — three clips", position: 4,
    contents: [
      { key: "eyebrow",      label: "Eyebrow",
        en: "In her words", ar: "" },
      { key: "clip_1_title", label: "Clip 1 title",
        en: "What is worth your money?", ar: "" },
      { key: "clip_2_title", label: "Clip 2 title",
        en: "How I say no to a patient", ar: "" },
      { key: "clip_3_title", label: "Clip 3 title",
        en: "What I'd tell my best friend", ar: "" }
    ]
  },
  {
    kind: "drmaysa_cta", label: "Closing CTA", position: 5,
    contents: [
      { key: "title_1",   label: "Title part 1 (before emphasis)",
        en: "Request a private consultation with", ar: "" },
      { key: "title_em",  label: "Title emphasis span",
        en: "Dr. Maysa.", ar: "" },
      { key: "body",      label: "Body text",
        en: "All initial consultations are conducted personally by Dr. Maysa.", ar: "" },
      { key: "cta_label", label: "CTA button label",
        en: "Begin a private inquiry", ar: "" }
    ]
  }
])
