# Bridal Concierge page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/bridal/show.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# HTML entities in the original markup (&amp;) are converted to literal
# Unicode characters here so `<%=` escaping renders them correctly without
# double-encoding. The "Request your Bride's 180 plan." CTA subtext and the
# concierge-card link/body keep the literal "BRIDE" codeword and the arrow
# "→" as originally hardcoded; only the surrounding copy is split into
# editable fields around that fixed markup/codeword.
# Form fields, checklist logic, links and BridalLead/params code are left
# untouched — only static copy is migrated.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("bridal", [
  {
    kind: "bridal_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "Bridal Concierge · Riyadh", ar: "" },
      { key: "title_1", label: "Title line 1",
        en: "Skin,", ar: "" },
      { key: "title_2", label: "Title line 2",
        en: "measured.", ar: "" },
      { key: "title_em", label: "Title line 3 (emphasis)",
        en: "Confidence, quiet.", ar: "" },
      { key: "lead", label: "Lead paragraph", content_type: "richtext",
        en: "The doctor-led skin clinic for women in Riyadh — where every plan is read, written, and signed by Dr. Maysa.",
        ar: "" },
      { key: "date_label", label: "Wedding-date input label",
        en: "Tell us your wedding date", ar: "" }
    ]
  },
  {
    kind: "bridal_countdown", label: "Countdown messages", position: 1,
    contents: [
      { key: "ample", label: "Ample-time message",
        en: "There is ample time to plan calmly, in the right order.", ar: "" },
      { key: "ideal", label: "Ideal-window message",
        en: "An ideal window — the Bride's 180 fits beautifully.", ar: "" },
      { key: "soon", label: "Soon-but-workable message",
        en: "Close, but workable — we'll prioritise what matters most.", ar: "" },
      { key: "today", label: "Urgent (today) message",
        en: "Let's speak today — we'll make the most of every week.", ar: "" },
      { key: "days_label", label: "Days-remaining label",
        en: "days to plan, calmly.", ar: "" }
    ]
  },
  {
    kind: "bridal_timeline", label: "The Bride's 180 timeline", position: 2,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The Bride's 180", ar: "" },
      { key: "title", label: "Section title",
        en: "Six months, planned in the right order — so nothing is rushed at the end.", ar: "" },
      { key: "stage_1_num", label: "Stage 1 number label",
        en: "Months 1–2", ar: "" },
      { key: "stage_1_title", label: "Stage 1 title",
        en: "Foundation", ar: "" },
      { key: "stage_1_body", label: "Stage 1 body", content_type: "richtext",
        en: "Diagnose, calm and correct. The slow, invisible work that everything later depends on.",
        ar: "" },
      { key: "stage_2_num", label: "Stage 2 number label",
        en: "Months 3–4", ar: "" },
      { key: "stage_2_title", label: "Stage 2 title",
        en: "Build", ar: "" },
      { key: "stage_2_body", label: "Stage 2 body", content_type: "richtext",
        en: "Glow, contour and hair density — sequenced, then reviewed against where you began.",
        ar: "" },
      { key: "stage_3_num", label: "Stage 3 number label",
        en: "Months 5–6", ar: "" },
      { key: "stage_3_title", label: "Stage 3 title",
        en: "Polish & lock", ar: "" },
      { key: "stage_3_body", label: "Stage 3 body", content_type: "richtext",
        en: "Refinement, then a no-experiments rule. The last fortnight is for rest, not risk.",
        ar: "" }
    ]
  },
  {
    kind: "bridal_pillars", label: "Planned / Flexible / Locked", position: 3,
    contents: [
      { key: "pillar_1_title", label: "Pillar 1 title",
        en: "Planned", ar: "" },
      { key: "pillar_1_body", label: "Pillar 1 body", content_type: "richtext",
        en: "Every step mapped to your date, so the work happens early and gently.",
        ar: "" },
      { key: "pillar_2_title", label: "Pillar 2 title",
        en: "Flexible", ar: "" },
      { key: "pillar_2_body", label: "Pillar 2 body", content_type: "richtext",
        en: "Room to adjust as your skin responds — reviewed, never improvised.",
        ar: "" },
      { key: "pillar_3_title", label: "Pillar 3 title",
        en: "Locked", ar: "" },
      { key: "pillar_3_body", label: "Pillar 3 body", content_type: "richtext",
        en: "No new treatments in the final two weeks. The plan closes, and you simply arrive.",
        ar: "" }
    ]
  },
  {
    kind: "bridal_quotes", label: "Bride quotes", position: 4,
    contents: [
      { key: "quote_1_text", label: "Quote 1 text", content_type: "richtext",
        en: "Everything was decided months before. The last week, I just slept.", ar: "" },
      { key: "quote_1_by", label: "Quote 1 attribution",
        en: "L.M. · 2024", ar: "" },
      { key: "quote_2_text", label: "Quote 2 text", content_type: "richtext",
        en: "No one could point to one thing. I just looked like myself, rested.", ar: "" },
      { key: "quote_2_by", label: "Quote 2 attribution",
        en: "A.R. · 2025", ar: "" },
      { key: "quote_3_text", label: "Quote 3 text", content_type: "richtext",
        en: "My mother started her own quiet plan beside mine. We came together.", ar: "" },
      { key: "quote_3_by", label: "Quote 3 attribution",
        en: "F.K. · 2025", ar: "" }
    ]
  },
  {
    kind: "bridal_concierge", label: "Mother & sister concierge card", position: 5,
    contents: [
      { key: "title", label: "Card title",
        en: "For the mother & sister of the bride.", ar: "" },
      { key: "body", label: "Card body", content_type: "richtext",
        en: "A quiet parallel plan, arranged with the same discretion. Ask us during your consultation.",
        ar: "" },
      { key: "link", label: "Link label",
        en: "Ask privately →", ar: "" }
    ]
  },
  {
    kind: "bridal_checklist", label: "Checklist lead form", position: 6,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The 6-month bridal checklist", ar: "" },
      { key: "title", label: "Title",
        en: "A quiet plan, sent to your inbox.", ar: "" },
      { key: "sent_message", label: "Thank-you message (after submit)",
        en: "Thank you — your checklist is on its way.", ar: "" },
      { key: "email_label", label: "Email field label",
        en: "Your email", ar: "" },
      { key: "submit_label", label: "Submit button label",
        en: "Send me the checklist", ar: "" },
      { key: "note", label: "Privacy note below form",
        en: "One email. No list, no follow-ups you didn't ask for.", ar: "" }
    ]
  },
  {
    kind: "bridal_cta", label: "Final CTA", position: 7,
    contents: [
      { key: "title", label: "Title",
        en: "Request your Bride's 180 plan.", ar: "" },
      { key: "subtext", label: "Subtext (before codeword)",
        en: "Send the codeword", ar: "" },
      { key: "subtext_suffix", label: "Subtext (after codeword)",
        en: "on WhatsApp.", ar: "" },
      { key: "button", label: "Button label",
        en: "Begin the conversation", ar: "" }
    ]
  }
])
