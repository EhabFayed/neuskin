# The five launch treatment outcomes — previously the "treatment_outcomes"
# section kinds (outcome_<slug>); copy is the content team's approved text
# ("NeuSkin Website content.pdf", July 2026). Idempotent by slug.
TREATMENT_SEEDS = [
  { slug: "skin", position: 1, protocol_slug: "90-day-glow-reset",
    title_en: "Tired, dull skin", title_ar: "",
    headline_en: "Restoring vitality to tired, dull skin",
    headline_ar: "استعادة الحيوية والنضارة لبشرتكِ",
    look_en: "Skin that has lost its radiance — no longer catching the light as it once did, uneven in tone, and slow to recover after a demanding week. Not damaged. Simply tired.",
    look_ar: "بشرةٌ فقدت بريقها المعتاد؛ لم تعد تعكس الضوءَ كما كانت، لونها غير متجانس، وتستغرق وقتاً أطول للتعافي بعد أسبوعٍ حافل. ليست تالفة، بل مُرهقة فحسب.",
    how_en: "We begin by understanding the \"why,\" rather than reaching for a device. Often, dullness is a story of barrier, hydration, and turnover. From there, a sequenced plan rebuilds clarity over the coming weeks, measured against your skin's starting point.",
    how_ar: "نبدأُ بفهم الأسباب قبل أن نلجأ لأي جهاز. فغالباً ما يكون الشحوب نتيجةً لاختلالٍ في حاجز البشرة أو الترطيب أو معدل التجدد. بناءً على ذلك، نضعُ لكِ بروتوكولاً متسلسلاً يعيد للبشرة صفاءها تدريجياً، مع قياس التقدم مقارنةً بحالتكِ في البداية.",
    view_en: "Tired skin is rarely one problem; it’s usually three small ones compounding. Treat the cause in order and the glow returns on its own — chasing it with a single facial almost never holds.",
    view_ar: "" },
  { slug: "hair", position: 2, protocol_slug: "reset-crown",
    title_en: "Thinning & shedding", title_ar: "",
    headline_en: "Comprehensive care for thinning hair",
    headline_ar: "عناية متكاملة لتقوية الشعر والحد من تساقطه",
    look_en: "A part that widens. A ponytail that feels thinner in the hand. More strands than you remember on the pillow — often after a baby or a stretch of stress.",
    look_ar: "فرقُ الشعر الذي يزداد اتساعاً، ذيلُ حصانٍ تلمسين خفته بيدك، وخصلاتٌ أكثر من المعتاد تجدينها على وسادتكِ — غالباً ما تلاحظين ذلك بعد الولادة أو فتراتِ الضغطِ النفسي.",
    how_en: "We assess the scalp clinically to identify treatable causes, then build a regenerative protocol to slow shedding and support density. We review all progress against your starting point, ensuring the results are real, not just hopeful.",
    how_ar: "نبدأ بتقييم فروة الرأس سريرياً للبحث عن مسبباتٍ قابلةٍ للعلاج، ثم نبني بروتوكولاً تجديدياً للحد من التساقط وتعزيز الكثافة؛ حيث نراجع النتائج مقارنةً بحالتكِ الأصلية، ليكون التقدم حقيقياً وملموساً، لا مجرد آمال.",
    view_en: "The earlier we see shedding, the more we can do. The follicle is patient, but it isn’t infinitely so — measured intervention beats another year of waiting for a shampoo to work.",
    view_ar: "" },
  { slug: "body", position: 3, protocol_slug: "8-week-sculpt",
    title_en: "Tone & contour", title_ar: "",
    headline_en: "Sculpting and toning your natural silhouette",
    headline_ar: "نحتُ وتحديد ملامح قوامكِ بأناقة",
    look_en: "You train, you eat well, yet a gap remains between your efforts and the results. There is softness where you desire definition, and your posture has lost its youthful lift.",
    look_ar: "تلتزمين بالتمارين الرياضية وتناول الغذاء الصحي، ومع ذلك لا تزال هناك فجوة بين مجهودكِ وبين النتائج التي تطمحين إليها. ليونةٌ في أماكنَ تتمنين فيها قواماً مشدوداً، وانحناءةٌ في القوام تحتاجُ إلى استعادةِ حيويتها.",
    how_en: "Our eight-week, device-led protocol reinforces muscle tone, contour, and posture. We rely on standardized measurements — at both the start and the finish — to ensure your progress is precisely documented, not assumed.",
    how_ar: "نعتمدُ بروتوكولاً مُكثّفاً يمتدُّ لثمانيةِ أسابيع، مدعوماً بأحدث التقنيات لتعزيزِ قوةِ العضلات، ونحتِ القوام، وتحسينِ استقامةِ الجسم. ونعتمدُ في رحلتنا على قياساتٍ دقيقةٍ وموحدةٍ في بدايةِ البرنامجِ ونهايته، لنضمنَ توثيقَ النتائجِ بدقةٍ تامة، لا مجرد التكهن بها.",
    view_en: "Body work should support your effort, never replace it. We measure posture and definition — not the scale — because that’s what actually changes how clothes sit and how you stand.",
    view_ar: "" },
  { slug: "injectables", position: 4, protocol_slug: "neuskin-method",
    title_en: "Lines & volume", title_ar: "",
    headline_en: "Preserving natural contours before any intervention",
    headline_ar: "الحفاظ على جمال ملامحكِ قبل أي إجراء",
    look_en: "Early lines, a slight loss of volume, and a face that appears tired before you actually feel it. The natural instinct is to ask for a syringe, but ours is to ask why first.",
    look_ar: "خطوطٌ أولية، فقدانٌ طفيفٌ في الامتلاء، ووجهٌ يبدو مُرهقاً قبل أن تشعري أنتِ بذلك. الغريزةُ الطبيعيةُ تدفعكِ لطلبِ \"حقن الفيلر\"، لكنَّ نهجنا يبدأُ دائماً بطرحِ سؤال \"لماذا\".",
    how_en: "Every injectable decision at NeuSkin follows a diagnosis, not a request. When it is right, our approach is precise and conservative. When it isn't, we say so — and treat the underlying cause instead.",
    how_ar: "في نيوسكن، كلُّ قرارٍ بالحقنِ يسبقهُ تشخيصٌ دقيق، لا مجردُ طلبٍ علاجي. عندما يكون الإجراءُ مناسباً، فإننا نطبقهُ بدقةٍ وتحفظٍ تام. وإن لم يكن كذلك، فإننا نصارحكِ بذلك، ونعالجُ السببَ الجذريَّ للمشكلةِ بدلاً من ذلك.",
    view_en: "The best injectable result is the one nobody can name. Restraint is a clinical skill; the goal is you, rested — never you, edited.",
    view_ar: "" },
  { slug: "devices", position: 5, protocol_slug: "neuskin-method",
    title_en: "Advanced devices", title_ar: "",
    headline_en: "Our devices: True purpose, visible results",
    headline_ar: "أجهزتنا: الغاية الحقيقية، والنتائج الملموسة",
    look_en: "EmFace, EmSculpt Neo, lasers, exosomes, polynucleotides — a vocabulary the industry loves, yet one that patients rarely need to navigate by name.",
    look_ar: "تقنياتٌ مثل EmFace وEmSculpt Neo، والليزر، والإكسوسومات، والبولينيوكليوتيدات؛ هي مصطلحاتٌ يعشقها قطاع التجميل، لكنها في الواقع تفاصيل تقنية لا تحتاج المريضة للانشغال بتسمياتها.",
    how_en: "We choose the device to fit the outcome, never the other way around. Each is simply a tool within a doctor-written plan — sequenced, measured, and only used when it earns its place.",
    how_ar: "نحن نختار الجهاز ليلائم النتيجة المطلوبة، لا العكس. فكل جهازٍ لدينا هو مجرد أداةٍ ضمن خطةٍ مُحكمةٍ وضعها الطبيب؛ خطةٍ مُرتّبةٍ، ومدروسةٍ، ولا يُستخدم فيها أي جهازٍ إلا عندما يستحقُّ مكانهُ في رحلتكِ العلاجية.",
    view_en: "A device is a means, not a headline. If a clinic is selling you the machine before the diagnosis, you’re being sold to — not treated.",
    view_ar: "" }
].freeze

TREATMENT_SEEDS.each do |attrs|
  Treatment.find_or_initialize_by(slug: attrs[:slug]).update!(attrs)
end

puts "Seeded #{Treatment.count} treatments."
