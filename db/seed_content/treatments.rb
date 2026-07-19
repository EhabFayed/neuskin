# Treatments (by outcome) page content seed.
#
# EN/AR values reflect the content team's approved copy
# ("NeuSkin Website content.pdf", July 2026).
#
# Note: the outcome CARDS on this page are Treatment records (see
# db/seeds/treatments.rb and Admin::TreatmentsController) — this file only
# seeds the page's own hero, footer and CTA chrome.
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
        en: "We begin with", ar: "نبدأُ من" },
      { key: "title_em", label: "Title emphasis span",
        en: "the outcome you desire.", ar: "النتيجةِ التي تطمحين إليها." },
      { key: "lead",     label: "Lead paragraph", content_type: "richtext",
        en: "Searching for a specific procedure? Instead, look toward the change you wish to see. We guide your journey, connecting your goals to the precise protocol that delivers them.",
        ar: "تبحثين عن إجراءٍ بعينه؟ وجهي تركيزكِ نحو التغيير الذي تطمحين إليه. نحن هنا لنرسم معكِ خارطة الطريق، ونربط طموحاتكِ بالبروتوكول الدقيقِ الذي يُحقق لكِ النتيجةَ المرجوة." }
    ]
  },
  {
    kind: "treatments_footer", label: "Footer link", position: 1,
    contents: [
      { key: "protocols_link", label: "\"View all protocols\" link text",
        en: "View all six protocols →", ar: "" },
      { key: "card_cta", label: "Card hover line (\"See the approach\")",
        en: "See the approach →", ar: "" }
    ]
  },
  {
    kind: "treatments_cta", label: "Closing CTA", position: 2,
    contents: [
      { key: "kicker",   label: "Kicker (italic line)",
        en: "Not sure where to start?", ar: "" },
      { key: "title",    label: "Title (before emphasis)",
        en: "Begin with the", ar: "" },
      { key: "title_em", label: "Title emphasis span",
        en: "Maysa Method™", ar: "" },
      { key: "button",   label: "Button label",
        en: "Request the assessment", ar: "" }
    ]
  }
])
