# The Clinic page content seed.
#
# EN/AR values reflect the content team's approved copy
# ("NeuSkin Website content.pdf", July 2026). Where the PDF gave no Arabic,
# ar: stays blank and the page falls back to English on the AR locale.
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
        en: "A private clinic in Al Malqa, built around one question:",
        ar: "عيادةٌ خاصة في حي الملقا، محورها تساؤلٌ واحد:" },
      { key: "title_em",  label: "Title emphasis span",
        en: "what will your skin look like in five years?",
        ar: "كيف ستكون بشرتكِ بعد خمس سنوات؟" }
    ]
  },
  {
    kind: "clinic_philosophy", label: "Philosophy — design statement + body", position: 1,
    contents: [
      { key: "statement_1", label: "Statement line 1 (masked reveal)",
        en: "We believe a clinic should be measured",
        ar: "نؤمنُ بأنَّ مقياسَ العيادةِ" },
      { key: "statement_2", label: "Statement line 2 (before emphasis)",
        en: "by", ar: "هو" },
      { key: "statement_2_em", label: "Statement line 2 emphasis span",
        en: "what it refuses to do.", ar: "ما تترفعُ عن فعله." },
      { key: "body_1", label: "Body paragraph 1", content_type: "richtext",
        en: "NeuSkin began with a simple belief: skin care should not be a list of treatments sold from a menu. We chose the opposite — a quiet room, a doctor who truly examines, and a plan crafted for one person at a time.",
        ar: "ولدت \"نيوسكن\" من فكرةٍ بسيطة: العنايةُ بالبشرة ليست مجرد قائمةِ خدماتٍ تُعرضُ للبيع. اخترنا النقيض؛ غرفاً هادئة، طبيبةً تُعنى بالتفاصيل، وخططاً علاجيةً تُصاغُ خصيصاً لكلِّ حالةٍ على حِدة." },
      { key: "body_2", label: "Body paragraph 2", content_type: "richtext",
        en: "So we built a clinic around diagnosis, not display. Every journey begins with the NeuSkin Method™ — a full reading of skin, hair, and body — before any recommendation. We chose Al Malqa for its quiet discretion, and we focus on women because they deserve to be heard, not just sold to.",
        ar: "أسسنا عيادةً جوهرها التشخيصُ لا العرض. تبدأ رحلتكِ بمنهجية \"نيوسكن\" (NeuSkin Method™) — قراءةٌ شاملةٌ للبشرةِ والشعرِ والجسم — قبل أن نقترحَ أيَّ إجراء. اخترنا \"حي الملقا\" لخصوصيته، وخصصنا اهتمامنا للمرأة؛ لأنها تستحقُّ من يُنصتُ إليها، لا من يبيعها وعوداً." },
      { key: "body_3", label: "Body paragraph 3", content_type: "richtext",
        en: "We are not the loudest clinic in the city. We intend to be the one you keep.",
        ar: "قد لا نكونُ العيادةَ الأكثر صخباً في المدينة، لكننا نطمحُ لنكونَ العيادةَ التي تثقينَ بها دوماً." },
      { key: "sign", label: "Signature",
        en: "— The NeuSkin Team", ar: "— فريق نيوسكن" }
    ]
  },
  {
    kind: "clinic_space", label: "The Space — photo grid captions", position: 2,
    contents: [
      { key: "eyebrow",     label: "Eyebrow",
        en: "The Space", ar: "" },
      { key: "shot_1_caption", label: "Photo 1 caption (lounge)",
        en: "The lounge", ar: "صالة الاستقبال" },
      { key: "shot_2_caption", label: "Photo 2 caption (diptyque)",
        en: "In the detail", ar: "في التفاصيل" },
      { key: "shot_3_caption", label: "Photo 3 caption (device room)",
        en: "Device room", ar: "غرفة الأجهزة" },
      { key: "shot_4_caption", label: "Photo 4 caption (treatment room)",
        en: "Treatment room", ar: "غرفة الإجراءات" },
      { key: "shot_5_caption", label: "Photo 5 caption (entrance)",
        en: "The entrance", ar: "المدخل" }
    ]
  },
  {
    kind: "clinic_journey", label: "The four-step patient journey", position: 3,
    contents: [
      { key: "eyebrow",      label: "Eyebrow",
        en: "How we work", ar: "" },
      { key: "title",        label: "Section title",
        en: "The four-step patient journey",
        ar: "رحلة المريض: أربع خطوات نحو بشرةٍ متجددة" },
      { key: "step_1_n",     label: "Step 1 number",
        en: "01", ar: "" },
      { key: "step_1_title", label: "Step 1 title",
        en: "Inquire", ar: "الاستفسار" },
      { key: "step_1_body",  label: "Step 1 body",
        en: "A private WhatsApp message or form, reviewed personally by our patient relations lead.",
        ar: "رسالةٌ خاصة عبر واتساب أو نموذج، نراجعها بعنايةٍ واهتمام من قِبل مسؤولة علاقات المرضى." },
      { key: "step_2_n",     label: "Step 2 number",
        en: "02", ar: "" },
      { key: "step_2_title", label: "Step 2 title",
        en: "Consult", ar: "الاستشارة" },
      { key: "step_2_body",  label: "Step 2 body",
        en: "A 60-minute NeuSkin Method™ assessment. Doctor-led, diagnostic. No treatment performed.",
        ar: "جلسة تقييم شاملة لمدة 60 دقيقة وفق منهجية \"نيوسكن\" (NeuSkin Method™). بقيادةٍ طبيةٍ دقيقة، مخصصة للتشخيص فقط دون إجراء أيّ جلساتٍ علاجية." },
      { key: "step_3_n",     label: "Step 3 number",
        en: "03", ar: "" },
      { key: "step_3_title", label: "Step 3 title",
        en: "Plan", ar: "الخطة" },
      { key: "step_3_body",  label: "Step 3 body",
        en: "A written 12-month roadmap — skin, hair, body, lifestyle. Yours to keep, whatever you decide.",
        ar: "خارطةُ طريقٍ مكتوبةٍ لـ 12 شهراً، تغطي البشرة، الشعر، الجسم، ونمط الحياة. هي ملكٌ لكِ، لتختاري ما يناسبكِ في أي وقت." },
      { key: "step_4_n",     label: "Step 4 number",
        en: "04", ar: "" },
      { key: "step_4_title", label: "Step 4 title",
        en: "Treat", ar: "العلاج" },
      { key: "step_4_body",  label: "Step 4 body",
        en: "Sequenced sessions with quarterly review, adjusted as your skin responds.",
        ar: "جلساتٌ علاجيةٌ متسلسلة مع مراجعاتٍ ربع سنوية، نعدّلها باستمرار لتواكبَ استجابةَ بشرتكِ وتطورها." }
    ]
  },
  {
    kind: "clinic_credentials", label: "Credentials, in plain language", position: 4,
    contents: [
      { key: "eyebrow", label: "Eyebrow",
        en: "The standard", ar: "" },
      { key: "title",   label: "Section title",
        en: "Credentials, refined for clarity.", ar: "تراخيصنا، بصياغةٍ أكثر وضوحاً." },
      { key: "body_1",  label: "Body paragraph 1", content_type: "richtext",
        en: "Transparency is our foundational protocol. We present our licenses, consent policies, and clinical realities exactly as they are — crafted for your peace of mind, not for regulatory convenience.",
        ar: "الشفافيةُ هي بروتوكولنا الأساسي. نعرضُ تراخيصنا، وسياساتِ الموافقة، وواقعنا الطبي بكل صراحة؛ صُيغت من أجلكِ أنتِ، لنمنحكِ راحةَ البالِ التي تستحقينها." },
      { key: "spec_1_k", label: "Spec 1 label",
        en: "SFDA / MOH license", ar: "ترخيص هيئة الغذاء والدواء / وزارة الصحة" },
      { key: "spec_1_v", label: "Spec 1 value",
        en: "No. 0000000000", ar: "رقم 0000000000" },
      { key: "spec_2_k", label: "Spec 2 label",
        en: "Practitioner licenses", ar: "تراخيص الممارسين" },
      { key: "spec_2_v", label: "Spec 2 value",
        en: "On file · verifiable", ar: "متاحة · قابلة للتحقق" },
      { key: "spec_3_k", label: "Spec 3 label",
        en: "Patient privacy", ar: "خصوصية المريض" },
      { key: "spec_3_v", label: "Spec 3 value",
        en: "PDPL compliant", ar: "متوافقة مع نظام حماية البيانات" },
      { key: "spec_4_k", label: "Spec 4 label",
        en: "Photographic consent", ar: "الموافقة على التصوير" },
      { key: "spec_4_v", label: "Spec 4 value",
        en: "Explicit · withdrawable", ar: "صريحة · قابلة للانسحاب" },
      { key: "body_2",  label: "Body paragraph 2 (footer note)", content_type: "richtext",
        en: "Aesthetic results are personal, not guaranteed. We believe in open dialogue over clinical ambiguity, and we choose to state this here, plainly, rather than hidden in the fine print.",
        ar: "النتائجُ الجماليةُ شخصيةٌ ولا تخضعُ للوعودِ الجازمة. نؤمنُ بأنَّ الحوارَ الصريحَ أفضلُ من الغموضِ الطبي، ونختارُ أن نخبرك بذلك بوضوح، بدلاً من إخفائه في الهوامش." }
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
