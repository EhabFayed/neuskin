# FAQ page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/faq.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("faq", [
  {
    kind: "faq_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "Frequently Asked", ar: "" },
      { key: "title_1", label: "Title line 1",
        en: "The questions", ar: "" },
      { key: "title_em", label: "Title line 2 (emphasis)",
        en: "before the question.", ar: "" },
      { key: "search_placeholder", label: "Search input placeholder",
        en: "Search the questions", ar: "" },
      { key: "empty_state", label: "No-results message",
        en: "No questions match.", ar: "" }
    ]
  },
  {
    kind: "faq_items", label: "Question groups", position: 1,
    contents: [
      { key: "group_1_title", label: "Group 1 title",
        en: "Before you come in", ar: "" },
      { key: "q_1_question", label: "Q1 question",
        en: "Do you publish a price list?", ar: "" },
      { key: "q_1_answer", label: "Q1 answer", content_type: "richtext",
        en: "No. Care is arranged by consultation, never sold from a menu. We discuss investment privately once we understand what your skin actually needs.",
        ar: "" },
      { key: "q_2_question", label: "Q2 question",
        en: "How do I start?", ar: "" },
      { key: "q_2_answer", label: "Q2 answer", content_type: "richtext",
        en: "Send a private inquiry — on WhatsApp or through the form. Dr. Maysa or our patient relations lead reviews every message personally.",
        ar: "" },
      { key: "q_3_question", label: "Q3 question",
        en: "Is the first visit a treatment?", ar: "" },
      { key: "q_3_answer", label: "Q3 answer", content_type: "richtext",
        en: "No. The first appointment is a doctor-led diagnostic assessment. Nothing is performed; we read your skin and write a plan.",
        ar: "" },

      { key: "group_2_title", label: "Group 2 title",
        en: "How care works", ar: "" },
      { key: "q_4_question", label: "Q4 question",
        en: "Why a twelve-month plan?", ar: "" },
      { key: "q_4_answer", label: "Q4 answer", content_type: "richtext",
        en: "Good skin is sequenced over time, not forced in a single session. We plan across quarters and review the results every three months.",
        ar: "" },
      { key: "q_5_question", label: "Q5 question",
        en: "Will I see Dr. Maysa herself?", ar: "" },
      { key: "q_5_answer", label: "Q5 answer", content_type: "richtext",
        en: "Your initial assessment is conducted personally by Dr. Maysa. Ongoing care may involve the wider medical team, always under her direction.",
        ar: "" },
      { key: "q_6_question", label: "Q6 question",
        en: "What if a treatment isn't right for me?", ar: "" },
      { key: "q_6_answer", label: "Q6 answer", content_type: "richtext",
        en: "Then we say so. Turning something down is part of the practice — we would rather keep your trust than sell you a session.",
        ar: "" },

      { key: "group_3_title", label: "Group 3 title",
        en: "Privacy & practicalities", ar: "" },
      { key: "q_7_question", label: "Q7 question",
        en: "How private is my information?", ar: "" },
      { key: "q_7_answer", label: "Q7 answer", content_type: "richtext",
        en: "Your inquiry is seen only by our patient relations lead and Dr. Maysa. We are PDPL compliant and store data securely.",
        ar: "" },
      { key: "q_8_question", label: "Q8 question",
        en: "Do you photograph patients?", ar: "" },
      { key: "q_8_answer", label: "Q8 answer", content_type: "richtext",
        en: "Only with separate, specific, written consent. Consent is never assumed and can be withdrawn at any time.",
        ar: "" },
      { key: "q_9_question", label: "Q9 question",
        en: "Where are you, and when are you open?", ar: "" },
      { key: "q_9_answer", label: "Q9 answer", content_type: "richtext",
        en: "Al Malqa, Riyadh. Saturday to Thursday, 10:00–22:00. Friday closed. The exact address is shared when we schedule.",
        ar: "" }
    ]
  }
])
