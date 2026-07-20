# Our Technologies page chrome content seed.
#
# EN/AR values are the content team's approved copy ("NeuSkin Website.pdf",
# July 2026 deck — "Our Technologies" section).
#
# The device flip cards are NOT covered here — they are Device records
# (db/seeds/devices.rb, dashboard → Devices), so editors can add and remove
# cards. Only the static page chrome (hero, intro, closing CTA) is CMS
# Section content.
#
# Images (attached via the dashboard, not seeded here):
#   tech_hero gallery — four device-room shots, branded one last (wider)
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("technologies", [
  {
    kind: "tech_hero", label: "Hero — split device-room composite", position: 0,
    contents: [
      { key: "eyebrow",  label: "Eyebrow",
        en: "Our Technologies", ar: "تقنياتنا" },
      { key: "title",    label: "Headline line 1",
        en: "Where Clinical Excellence", ar: "حيث يلتقي التميز الطبي" },
      { key: "title_em", label: "Headline line 2 (emphasis)",
        en: "Meets Human Grace.", ar: "برقيّ اللمسة الإنسانية." },
      { key: "sub",      label: "Sub-headline",
        en: "We believe true beauty is powered by science and defined by patience. Explore the innovative protocols that form the foundation of your NeuSkin journey.",
        ar: "نؤمن أن الجمال الحقيقي يستمد قوته من العلم، ويحدده الصبر. اكتشفي التقنيات المبتكرة التي تشكل أساس رحلتكِ معنا في 'نيوسكن'." },
      { key: "cta",      label: "Button label",
        en: "Explore Our Treatments", ar: "اكتشفي خدماتنا" }
    ]
  },
  {
    kind: "tech_intro", label: "The Science of You", position: 1,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The Standard", ar: "" },
      { key: "title",   label: "Heading",
        en: "The Science of You", ar: "العلم خلف الجمال" },
      { key: "body",    label: "Body text",
        en: "At NeuSkin, technology is a refined tool to honor your body's natural potential. We have selected a portfolio of FDA-cleared innovations that work in harmony with your physiology, prioritizing your long-term health and aesthetic goals.",
        ar: "في 'نيوسكن'، التكنولوجيا هي وسيلة دقيقة نكرّم بها جمالك الطبيعي. اخترنا بعناية تقنيات معتمدة عالمياً تعمل في تناغم مع طبيعة جسمك، واضعين صحتك على المدى الطويل ونتائجك المرجوة في مقدمة أولوياتنا." }
    ]
  },
  {
    kind: "tech_cta", label: "Closing CTA", position: 2,
    contents: [
      { key: "title",    label: "Heading",
        en: "Ready to experience the NeuSkin difference?", ar: "مستعدة لتجربة الفرق مع 'نيوسكن'؟" },
      { key: "title_em", label: "Heading (emphasis)",
        en: "Your transformation begins here.", ar: "رحلة جمالك تبدأ من هنا." },
      { key: "button",   label: "Button label",
        en: "Book Your Consultation", ar: "احجزي استشارتك" }
    ]
  }
])
