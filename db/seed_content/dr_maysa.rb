# Dr. Maysa page content seed.
#
# EN/AR values reflect the content team's approved copy
# ("NeuSkin Website content.pdf", July 2026). Where the PDF gave no Arabic,
# ar: stays blank and the page falls back to English on the AR locale.
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
        en: "“I prioritize the depth of one transformation over the volume of ten superficial appointments.”",
        ar: "“أؤمنُ بأنَّ أثراً واحداً أُتقنَهُ بعمق، خيرٌ من عشرةِ مواعيدَ عابرةٍ لا تتركُ سوى صخبٍ في جدولِ المواعيد.”" },
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
        en: "I specialized in dermatology to focus on skin, but in practice, I found something deeper: women who weren't ill, but had simply lost their way in a beauty industry that sold them everything — except the truth. They arrived with products and treatments, but never with a diagnosis.",
        ar: "تخصصتُ في الجلدية لأركز على البشرة، لكنني اكتشفتُ في الواقع ما هو أعمق: نساءٌ لسنَ مريضات، بل ضللنَ الطريق في صناعةٍ تبيعُهنَّ كل شيء.. إلا الحقيقة. يأتينَ إليّ محملاتٍ بمنتجاتٍ وقوائمَ علاجية، يغيبُ عنها الأهم دائماً: التشخيص." },
      { key: "pull_1",  label: "Pull quote 1",
        en: "“Skin speaks in data. My role is to listen before I act.”",
        ar: "“البشرةُ تتحدثُ لغةَ البيانات. مهمتي هي الإنصاتُ لها.. قبلَ اتخاذِ أيِّ قرار.”" },
      { key: "body_2",  label: "Body paragraph 2", content_type: "richtext",
        en: "At NeuSkin, I focus on understanding, not just intervening. Every patient is viewed as a whole — skin, hair, and biology — as one connected, living system. We take the time to decide, together, what truly serves you. Often, the most meaningful step is choosing to do less; that simplicity is the heart of my approach.",
        ar: "في \"نيوسكن\"، جُلُّ اهتمامي هو الفهم قبل التدخل. أرى المريضة كمنظومةٍ واحدةٍ متكاملة؛ بشرةً وشعراً وروحاً. نأخذ وقتنا لنقرر معاً ما تحتاجه بشرتكِ فعلاً. وكثيراً ما تكون النصيحة الأكثر أهمية هي \"البساطة\"، وهذا التريث هو جوهر فلسفتي." },
      { key: "body_3",  label: "Body paragraph 3", content_type: "richtext",
        en: "I am guided by clear boundaries. I believe in preserving the unique character of your face rather than chasing trends. I only perform procedures I can fully explain, and I never create a sense of urgency. Good skin is a quiet, steady journey — one we curate together, with patience and intention.",
        ar: "أسير في عملي وفق معايير واضحة. أؤمن بأنَّ الجمال يكمن في الحفاظ على ملامحكِ الفريدة، لا في ملاحقة الصيحات. لا أُجري أيَّ إجراءٍ قبل أن نُناقش تفاصيله معاً، ولا أعجل بالنتائج. البشرةُ الصحيةُ هي رحلةٌ هادئة ومستمرة، نعتني بمسارها معاً بكل صبرٍ وعناية." },
      { key: "pull_2",  label: "Pull quote 2",
        en: "“The most beautiful results are the ones that simply feel like ‘you’, only better.”",
        ar: "“أجملُ النتائج هي التي تمنحكِ شعوراً بأنكِ أنتِ.. ولكن بأفضلِ حالاتكِ.”" },
      { key: "body_4",  label: "Body paragraph 4", content_type: "richtext",
        en: "I believe in proof, not promises. We document your starting point and track every change, so your progress is clear, not just a feeling. Being 'doctor-led' here means you're not just getting a name on a door — you're getting a real, honest record of your results that you can actually hold.",
        ar: "أؤمنُ بالنتائج لا بالوعود. نوثقُ بدايتك ونتابعُ كلَّ تغييرٍ نلمسه، ليكونَ تقدمكِ حقيقياً وواضحاً أمام عينيكِ، لا مجرد شعور. القيادةُ الطبيةُ هنا ليست مجرد اسمٍ على الأبواب، بل هي سجلٌّ صادقٌ لنتائجكِ، يُمكنكِ الاحتفاظُ به." },
      { key: "sign",    label: "Signature",
        en: "— Maysa", ar: "— ميسا" }
    ]
  },
  {
    kind: "drmaysa_method", label: "The NeuSkin Method™ — three steps", position: 3,
    contents: [
      { key: "eyebrow",      label: "Eyebrow",
        en: "The NeuSkin Method™", ar: "" },
      { key: "title",        label: "Section title",
        en: "Three steps. One connected system.", ar: "ثلاث خطوات. منظومةٌ واحدة متكاملة." },
      { key: "step_1_n",     label: "Step 1 number",
        en: "01", ar: "" },
      { key: "step_1_title", label: "Step 1 title",
        en: "Diagnostic mapping", ar: "خارطة التشخيص" },
      { key: "step_1_body",  label: "Step 1 body",
        en: "A deep look at your skin, hair, and body — led by me.",
        ar: "رؤيةٌ متعمقةٌ لبشرتكِ وشعركِ وجسدكِ — تحت إشرافي الشخصي." },
      { key: "step_2_n",     label: "Step 2 number",
        en: "02", ar: "" },
      { key: "step_2_title", label: "Step 2 title",
        en: "The 12-month plan", ar: "خطة الـ 12 شهراً" },
      { key: "step_2_body",  label: "Step 2 body",
        en: "A personal roadmap for your skin and lifestyle — yours to keep.",
        ar: "خارطةُ طريقٍ شخصية لجمالِ بشرتكِ وأسلوب حياتكِ — صُممت لتكون بين يديكِ." },
      { key: "step_3_n",     label: "Step 3 number",
        en: "03", ar: "" },
      { key: "step_3_title", label: "Step 3 title",
        en: "Quarterly review", ar: "المراجعة الدورية" },
      { key: "step_3_body",  label: "Step 3 body",
        en: "We measure, compare, and adjust as your skin evolves.",
        ar: "نتابع، نقارن، ونطور خطواتنا مع كل مرحلةٍ تتجدد فيها بشرتكِ." },
      { key: "cta_label",    label: "CTA button label",
        en: "Request the NeuSkin Method™ Assessment", ar: "" }
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
        en: "Book your private consultation with", ar: "احجزي استشارتكِ الخاصة مع" },
      { key: "title_em",  label: "Title emphasis span",
        en: "Dr. Maysa.", ar: "دكتورة ميسا." },
      { key: "body",      label: "Body text",
        en: "Every initial consultation is held personally by me.",
        ar: "كلُّ جلسةِ تقييمٍ أولية، أُشرفُ عليها شخصياً." },
      { key: "cta_label", label: "CTA button label",
        en: "Start your private journey", ar: "ابدئي رحلتكِ الخاصة" }
    ]
  }
])
