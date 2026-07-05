# The Clinic page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/the_clinic.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("the_clinic", [
  {
    kind: "clinic_hero", label: "Hero — full-bleed interior", position: 0,
    contents: [
      { key: "eyebrow",   label: "Eyebrow",
        en: "About · The Clinic", ar: "" },
      { key: "title_1",   label: "Title part 1 (before emphasis)",
        en: "A private clinic in Al Malqa, built around one question:", ar: "" },
      { key: "title_em",  label: "Title emphasis span",
        en: "what will your skin look like in five years?", ar: "" }
    ]
  },
  {
    kind: "clinic_philosophy", label: "Philosophy — design statement + body", position: 1,
    contents: [
      { key: "statement_1", label: "Statement line 1 (masked reveal)",
        en: "We believe a clinic should be measured", ar: "" },
      { key: "statement_2", label: "Statement line 2 (before emphasis)",
        en: "by", ar: "" },
      { key: "statement_2_em", label: "Statement line 2 emphasis span",
        en: "what it refuses to do.", ar: "" },
      { key: "body_1", label: "Body paragraph 1", content_type: "richtext",
        en: "NeuSkin began with a frustration: skin care in Riyadh had become a list of treatments and a public price grid, sold the way a menu is sold. We wanted the opposite — a quiet room, a doctor who looks properly, and a plan written for one person at a time.",
        ar: "" },
      { key: "body_2", label: "Body paragraph 2", content_type: "richtext",
        en: "So we built a clinic around diagnosis, not display. Every patient begins with the Maysa Method™ — a full reading of skin, hair and body — before anything is recommended, let alone performed. We chose Al Malqa for its discretion, and we chose women as our focus because they have been sold to longest, and listened to least.",
        ar: "" },
      { key: "body_3", label: "Body paragraph 3", content_type: "richtext",
        en: "We are not the loudest clinic in the city. We intend to be the one you keep.",
        ar: "" },
      { key: "sign", label: "Signature",
        en: "— Dr. Maysa, Founder", ar: "" }
    ]
  },
  {
    kind: "clinic_space", label: "The Space — photo grid captions", position: 2,
    contents: [
      { key: "eyebrow",     label: "Eyebrow",
        en: "The Space", ar: "" },
      { key: "shot_1_caption", label: "Photo 1 caption (lounge)",
        en: "The lounge", ar: "" },
      { key: "shot_2_caption", label: "Photo 2 caption (diptyque)",
        en: "In the detail", ar: "" },
      { key: "shot_3_caption", label: "Photo 3 caption (device room)",
        en: "Device room", ar: "" },
      { key: "shot_4_caption", label: "Photo 4 caption (treatment room)",
        en: "Treatment room", ar: "" },
      { key: "shot_5_caption", label: "Photo 5 caption (entrance)",
        en: "The entrance", ar: "" }
    ]
  },
  {
    kind: "clinic_journey", label: "The four-step patient journey", position: 3,
    contents: [
      { key: "eyebrow",      label: "Eyebrow",
        en: "How we work", ar: "" },
      { key: "title",        label: "Section title",
        en: "The four-step patient journey", ar: "" },
      { key: "step_1_n",     label: "Step 1 number",
        en: "01", ar: "" },
      { key: "step_1_title", label: "Step 1 title",
        en: "Inquire", ar: "" },
      { key: "step_1_body",  label: "Step 1 body",
        en: "A private WhatsApp message or form, reviewed personally by our patient relations lead.", ar: "" },
      { key: "step_2_n",     label: "Step 2 number",
        en: "02", ar: "" },
      { key: "step_2_title", label: "Step 2 title",
        en: "Consult", ar: "" },
      { key: "step_2_body",  label: "Step 2 body",
        en: "A 60-minute Maysa Method™ assessment. Doctor-led, diagnostic. No treatment performed.", ar: "" },
      { key: "step_3_n",     label: "Step 3 number",
        en: "03", ar: "" },
      { key: "step_3_title", label: "Step 3 title",
        en: "Plan", ar: "" },
      { key: "step_3_body",  label: "Step 3 body",
        en: "A written 12-month roadmap — skin, hair, body, lifestyle. Yours to keep, whatever you decide.", ar: "" },
      { key: "step_4_n",     label: "Step 4 number",
        en: "04", ar: "" },
      { key: "step_4_title", label: "Step 4 title",
        en: "Treat", ar: "" },
      { key: "step_4_body",  label: "Step 4 body",
        en: "Sequenced sessions with quarterly review, adjusted as your skin responds.", ar: "" }
    ]
  },
  {
    kind: "clinic_credentials", label: "Credentials, in plain language", position: 4,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The standard", ar: "" },
      { key: "title",   label: "Section title",
        en: "Credentials, in plain language.", ar: "" },
      { key: "body_1",  label: "Body paragraph 1", content_type: "richtext",
        en: "We keep our compliance visible because trust should not be a leap of faith. Our licenses, our consent policy, and our honest limits are stated plainly — here, not buried.",
        ar: "" },
      { key: "spec_1_k", label: "Spec 1 label",
        en: "SFDA / MOH license", ar: "" },
      { key: "spec_1_v", label: "Spec 1 value",
        en: "No. 0000000000", ar: "" },
      { key: "spec_2_k", label: "Spec 2 label",
        en: "Practitioner licenses", ar: "" },
      { key: "spec_2_v", label: "Spec 2 value",
        en: "On file · verifiable", ar: "" },
      { key: "spec_3_k", label: "Spec 3 label",
        en: "Patient privacy", ar: "" },
      { key: "spec_3_v", label: "Spec 3 value",
        en: "PDPL compliant", ar: "" },
      { key: "spec_4_k", label: "Spec 4 label",
        en: "Photographic consent", ar: "" },
      { key: "spec_4_v", label: "Spec 4 value",
        en: "Explicit · withdrawable", ar: "" },
      { key: "body_2",  label: "Body paragraph 2", content_type: "richtext",
        en: "Results vary. Everything we do is subject to medical consultation and individual assessment — and we would rather tell you \"no\" than sell you a \"yes\".",
        ar: "" }
    ]
  },
  {
    kind: "clinic_cta", label: "Closing CTA", position: 5,
    contents: [
      { key: "title",     label: "Title",
        en: "Begin a quiet conversation.", ar: "" },
      { key: "body",      label: "Body text",
        en: "We reply, personally, Saturday to Thursday, 10:00–22:00.", ar: "" },
      { key: "cta_label", label: "CTA button label",
        en: "Speak with us", ar: "" }
    ]
  }
])
