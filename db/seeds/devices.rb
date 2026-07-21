# The seven launch device cards on /technologies — copy is the content team's
# approved text ("NeuSkin Website.pdf", July 2026 deck). Managed in the
# dashboard afterwards (Admin::DevicesController); images are attached there.
# Idempotent by name. Device names are brand names and are never translated.
DEVICE_SEEDS = [
  { name: "EMTONE", position: 1,
    tagline_en: "Harmonious Rejuvenation", tagline_ar: "نضارة متناغمة",
    body_en: "By blending thermal and mechanical energy, Emtone gently restores your skin's firmness and addresses cellulite, helping you feel smoother and more confident in your skin.",
    body_ar: "بدمج الطاقة الحرارية والميكانيكية، يعيد Emtone للبشرة تماسكها بنعومة، ويعالج مظهر السيلوليت، لتشعري ببشرة أكثر نعومة وثقة.",
    specs_en: "Uses targeted pressure energy combined with radiofrequency. Effective for abdomen, arms, thighs, love handles, and buttocks. Optimal results in 4–6 sessions. 64% more effective for elastin and 59% for collagen production.",
    specs_ar: "يستخدم طاقة الضغط المستهدفة مع الترددات الراديوية. فعال للبطن، الذراعين، الفخذين، وجانبي الخصر والأرداف. نتائج مثالية خلال 4-6 جلسات. أكثر فعالية بنسبة 64% في إنتاج الإيلاستين و59% في إنتاج الكولاجين." },
  { name: "EMFACE", position: 2,
    tagline_en: "Needle-Free Lift", tagline_ar: "رفع وشد بلا إبر",
    body_en: "This intelligent system simultaneously lifts, tightens, and tones the face, reducing wrinkles while improving facial symmetry without the need for needles.",
    body_ar: "يعمل هذا النظام الذكي على رفع وشد وتنعيم الوجه في آنٍ واحد، ليقلل التجاعيد ويحسن تناسق ملامحك بدون الحاجة لأي إبر.",
    specs_en: "Combines HIFEM and radiofrequency technologies. Reduces wrinkles by 37% and provides 23% more lift. Treats forehead, eyebrows, cheeks, and jawline. No downtime.",
    specs_ar: "يجمع بين تقنيات HIFEM والترددات الراديوية. يقلل التجاعيد بنسبة 37% ويزيد الشد بنسبة 23%. يعالج الجبهة، الحواجب، الخدين، وخط الفك. لا يتطلب فترة نقاهة." },
  { name: "EMSCULPT", position: 3,
    tagline_en: "Sculpted Strength", tagline_ar: "قوام منحوت",
    body_en: "Sculpt your body's natural shape. This system works with your muscles to define and contour, providing a refined, athletic look that perfectly complements your lifestyle.",
    body_ar: "انحتي قوامك بشكل طبيعي. يعمل هذا النظام مع عضلاتك لتعزيز رسمها وتحديد ملامح الجسم، ليمنحك المظهر المصقول والرياضي الذي يكمل أسلوب حياتك.",
    specs_en: "Combines RF heating and HIFEM in a single treatment. Targets abdomen, buttocks, arms, thighs, and calves. 30-minute sessions with zero downtime.",
    specs_ar: "يجمع بين التسخين بالترددات الراديوية وتقنية HIFEM في جلسة واحدة. يستهدف البطن، الأرداف، الذراعين، الفخذين، وعضلات الساق. جلسات مدتها 30 دقيقة بدون فترة نقاهة." },
  { name: "POTENZA", position: 4,
    tagline_en: "Advanced Skin Vitality", tagline_ar: "تجديد البشرة المتطور",
    body_en: "Bringing your skin back to life. This sophisticated microneedling treatment firms and brightens, helping you achieve a smoother, fuller, and more youthful complexion.",
    body_ar: "أعيدي الحياة لبشرتك. هذا العلاج الدقيق يشد البشرة ويمنحها إشراقاً، ليساعدك على الحصول على ملمس ناعم، ممتلئ، وأكثر شباباً.",
    specs_en: "Microneedling with radiofrequency using Tiger Tip technology. Designed to tighten skin, reduce fine lines, shrink pores, and diminish scars on face and body.",
    specs_ar: "وخز بالإبر الدقيقة مع الترددات الراديوية وتقنية Tiger Tip. مصمم لشد البشرة، تقليل الخطوط الدقيقة، تصغير المسام، وتقليل الندبات في الوجه والجسم." },
  { name: "ELITE IQ", position: 5,
    tagline_en: "Precision Care", tagline_ar: "دقة العناية",
    body_en: "Versatility meets safety. A dual-wavelength platform designed to address your skin's specific needs, from reducing redness to effective hair removal, ensuring results tailored to you.",
    body_ar: "حيث تلتقي المرونة بالأمان. جهاز ذو طول موجي مزدوج مصمم لتلبية احتياجات بشرتك الخاصة، من تقليل الاحمرار إلى إزالة الشعر، لضمان نتائج صُممت خصيصاً لك.",
    specs_en: "Dual-wavelength (ND YAG + ALEX). Features Skintel™, the world's first Melanin Reader™. Adjustable pulse width and various spot sizes for patient safety.",
    specs_ar: "طول موجي مزدوج (ND YAG + ALEX). يتميز بـ Skintel™، وهو أول قارئ للميلانين في العالم. عرض نبض قابل للتعديل وأحجام بقع متنوعة لضمان سلامة المريض." },
  { name: "REVLITE", position: 6,
    tagline_en: "Luminous Renewal", tagline_ar: "إشراقة وتجديد",
    body_en: "A multi-purpose medical treatment to improve skin texture. It works to brighten, refine pores, and diminish imperfections for a clearer, fairer complexion.",
    body_ar: "علاج طبي متعدد الأغراض لتحسين ملمس البشرة. يعمل على إشراقها، تصغير المسام، وتقليل العيوب للحصول على بشرة أكثر صفاءً ونضارة.",
    specs_en: "Q-Switched laser technology. Reduces oiliness, promotes collagen, minimizes pigmentation, acne scars, and fine lines.",
    specs_ar: "تقنية الليزر Q-Switched. يقلل الزيوت، يعزز الكولاجين، ويقلل التصبغات وندبات حب الشباب والخطوط الدقيقة." },
  { name: "EMERALD", position: 7,
    tagline_en: "Natural Fat Loss", tagline_ar: "فقدان الدهون الطبيعي",
    body_en: "Working in harmony with your body. This non-invasive treatment supports your natural metabolism to reduce stubborn fat, offering a gentle alternative to traditional methods.",
    body_ar: "يعمل بتناغم تام مع جسمك. هذا العلاج غير الجراحي يدعم معدل الأيض الطبيعي لتقليل الدهون العنيدة، مما يجعله بديلاً لطيفاً للطرق التقليدية.",
    specs_en: "FDA-cleared, non-invasive fat loss. Only device cleared for up to 40 BMI. Targets overall body circumference.",
    specs_ar: "علاج معتمد من FDA لفقدان الدهون غير الجراحي. الجهاز الوحيد المعتمد لمن لديهم مؤشر كتلة جسم يصل إلى 40. يستهدف محيط الجسم بالكامل." }
].freeze

DEVICE_SEEDS.each do |attrs|
  Device.find_or_initialize_by(name: attrs[:name]).update!(attrs)
end

puts "Seeded #{Device.count} devices."
