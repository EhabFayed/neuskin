# Idempotent seed of the six named protocols (architecture §06–§07).
# Re-runnable: keyed on slug.

protocols = [
  {
    slug: "maysa-method", position: 1, trademark: true, persona: "unsure", codeword: "METHOD",
    name_ar: "منهج ميساء", name_en: "The Maysa Method",
    promise_ar: "الأساس التشخيصي. حيث تبدأ كل خطة.",
    promise_en: "The diagnostic foundation. Where every plan begins.",
    duration_ar: "جلسة واحدة", duration_en: "1 session",
    meta_ar: "جلسة واحدة · المريضات لأول مرة", meta_en: "1 session · First-time patients",
    who_for_ar: "لكل من تبدأ رحلتها معنا — قبل أي علاج، نقرأ بشرتك أولًا.",
    who_for_en: "For anyone beginning with us — before any treatment, we read your skin first.",
    scope_ar: "تقييم تشخيصي لمدة ٦٠ دقيقة بقيادة الطبيبة. لا علاج يُجرى في هذه الجلسة.",
    scope_en: "A 60-minute doctor-led diagnostic assessment. No treatment is performed in this session.",
    excludes_ar: "لا تشمل أي إجراء علاجي — هذه جلسة قراءة وتخطيط فقط.",
    excludes_en: "Does not include any treatment — this is a reading-and-planning session only.",
    stages: [
      { week_ar: "الخطوة ١", week_en: "Step 1", title_ar: "التشخيص", title_en: "Diagnostic mapping",
        body_ar: "قياس أساسي للبشرة والشعر والجسم.", body_en: "A skin, hair and body baseline." },
      { week_ar: "الخطوة ٢", week_en: "Step 2", title_ar: "الخطة", title_en: "The written plan",
        body_ar: "خطة مكتوبة لاثني عشر شهرًا، لك أن تحتفظي بها.", body_en: "A written 12-month plan, yours to keep." },
      { week_ar: "الخطوة ٣", week_en: "Step 3", title_ar: "المراجعة", title_en: "Quarterly review",
        body_ar: "مراجعة وتعديل كل ثلاثة أشهر.", body_en: "Review and adjustment every quarter." }
    ],
    faqs: [
      { q_ar: "هل تُجرى أي علاجات في الجلسة الأولى؟", q_en: "Are any treatments done in the first session?",
        a_ar: "لا. الجلسة الأولى تشخيصية بالكامل.", a_en: "No. The first session is entirely diagnostic." }
    ],
    patient_story: { quote_ar: "لأول مرة شعرت أن أحدًا يخطّط لبشرتي، لا يبيع لي.",
                     quote_en: "For the first time, someone was planning for my skin — not selling to me.",
                     initials: "R.K.", year: "2025" }
  },
  {
    slug: "90-day-glow-reset", position: 2, persona: "tired", codeword: "GLOW",
    name_ar: "توهّج التسعين يومًا", name_en: "90-Day Glow Reset",
    promise_ar: "استعادة نضارة البشرة من الباهتية والملمس والتصبّغ الخفيف.",
    promise_en: "Skin restoration for dullness, texture and mild pigmentation.",
    duration_ar: "١٢ أسبوعًا", duration_en: "12 weeks",
    meta_ar: "١٢ أسبوعًا · إعادة ضبط البشرة", meta_en: "12 weeks · Skin reset",
    who_for_ar: "لمن تشعر أن بشرتها فقدت إشراقتها وتريد استعادتها بهدوء.",
    who_for_en: "For skin that has lost its glow, restored quietly over twelve weeks.",
    scope_ar: "بروتوكول متدرّج على ١٢ أسبوعًا للملمس والإشراق والتصبّغ الخفيف.",
    scope_en: "A staged 12-week protocol for texture, radiance and mild pigmentation.",
    excludes_ar: "لا يعالج التصبّغ العميق أو الحالات الطبية الجلدية.",
    excludes_en: "Does not address deep pigmentation or medical dermatological conditions.",
    stages: [
      { week_ar: "الأسابيع ١–٤", week_en: "Weeks 1–4", title_ar: "التهيئة", title_en: "Prepare",
        body_ar: "تنظيف عميق وتقوية حاجز البشرة.", body_en: "Deep cleansing and barrier repair." },
      { week_ar: "الأسابيع ٥–٨", week_en: "Weeks 5–8", title_ar: "التجديد", title_en: "Renew",
        body_ar: "تجديد الخلايا ومعالجة الملمس.", body_en: "Cell renewal and texture work." },
      { week_ar: "الأسابيع ٩–١٢", week_en: "Weeks 9–12", title_ar: "الإشراق", title_en: "Glow",
        body_ar: "توحيد اللون وتثبيت النتائج.", body_en: "Tone evening and results locked in." }
    ],
    faqs: [
      { q_ar: "متى أرى النتائج؟", q_en: "When will I see results?",
        a_ar: "عادةً تبدأ النتائج بالظهور من الأسبوع السادس.", a_en: "Results typically begin to show from week six." }
    ],
    patient_story: { quote_ar: "عادت بشرتي تتنفّس من جديد، دون مبالغة.",
                     quote_en: "My skin began to breathe again — without any exaggeration.",
                     initials: "L.A.", year: "2025" }
  },
  {
    slug: "brides-180", position: 3, persona: "bride", codeword: "BRIDE",
    name_ar: "عروس ١٨٠", name_en: "Bride's 180",
    promise_ar: "بشرتك بعد ستة أشهر — مخطّطة، بالترتيب، بيد الطبيبة.",
    promise_en: "Your skin in six months — planned, in order, by a doctor.",
    duration_ar: "١٨٠ يومًا", duration_en: "180 days",
    meta_ar: "١٨٠ يومًا · ما قبل الزفاف", meta_en: "180 days · Pre-wedding",
    who_for_ar: "للعروس التي يفصلها عن موعدها من ثلاثة إلى ستة أشهر.",
    who_for_en: "For the bride three to six months from her date.",
    scope_ar: "خطة شهرية للبشرة والشعر والجسم، متزامنة مع موعد الزفاف.",
    scope_en: "A month-by-month skin, hair and body plan, timed to the wedding date.",
    excludes_ar: "لا تشمل إجراءات اللحظة الأخيرة قبل الزفاف بأقل من أسبوعين.",
    excludes_en: "Does not include last-minute procedures within two weeks of the wedding.",
    stages: [
      { week_ar: "الأشهر ٦–٥", week_en: "Months 6–5", title_ar: "الأساس", title_en: "Foundation",
        body_ar: "تشخيص ووضع الخطة.", body_en: "Diagnosis and plan." },
      { week_ar: "الأشهر ٤–٢", week_en: "Months 4–2", title_ar: "العمل", title_en: "The work",
        body_ar: "البروتوكولات الأساسية للبشرة والشعر.", body_en: "Core skin and hair protocols." },
      { week_ar: "الشهر الأخير", week_en: "Final month", title_ar: "اللمسات", title_en: "Finishing",
        body_ar: "الإشراق النهائي والتثبيت.", body_en: "Final glow and locking in." }
    ],
    faqs: [
      { q_ar: "ماذا لو تأجّل موعد الزفاف؟", q_en: "What if my wedding date moves?",
        a_ar: "نعيد جدولة الخطة بالكامل وفق الموعد الجديد.", a_en: "We re-sequence the entire plan to the new date." }
    ],
    patient_story: { quote_ar: "وصلت إلى يومي وأنا مطمئنة، كل شيء كان مخطّطًا.",
                     quote_en: "I arrived at my day calm — everything had been planned.",
                     initials: "M.A.", year: "2025" }
  },
  {
    slug: "reset-crown", position: 4, persona: "hair", codeword: "CROWN",
    name_ar: "تاج التجدّد", name_en: "Reset Crown",
    promise_ar: "للشعر وفروة الرأس، لتساقط ما بعد الولادة والإجهاد.",
    promise_en: "Hair and scalp, for postpartum and stress shedding.",
    duration_ar: "١٢–١٦ أسبوعًا", duration_en: "12–16 weeks",
    meta_ar: "١٢–١٦ أسبوعًا · الشعر", meta_en: "12–16 weeks · Hair",
    who_for_ar: "لمن تواجه تساقطًا بعد الولادة أو نتيجة الإجهاد.",
    who_for_en: "For postpartum or stress-related shedding.",
    scope_ar: "بروتوكول لفروة الرأس يعالج التساقط ويعيد الكثافة.",
    scope_en: "A scalp protocol addressing shedding and restoring density.",
    excludes_ar: "لا يعالج الصلع الوراثي المتقدّم.", excludes_en: "Does not treat advanced genetic baldness.",
    stages: [
      { week_ar: "الأسابيع ١–٦", week_en: "Weeks 1–6", title_ar: "إيقاف التساقط", title_en: "Stop the shed",
        body_ar: "تهدئة فروة الرأس ووقف التساقط.", body_en: "Calm the scalp, stop the shedding." },
      { week_ar: "الأسابيع ٧–١٦", week_en: "Weeks 7–16", title_ar: "إعادة الكثافة", title_en: "Rebuild density",
        body_ar: "تحفيز النمو وزيادة الكثافة.", body_en: "Stimulate growth and density." }
    ],
    faqs: [
      { q_ar: "هل البروتوكول آمن بعد الولادة؟", q_en: "Is the protocol safe postpartum?",
        a_ar: "نعم، ويُصمّم خصيصًا لهذه المرحلة بعد التقييم.", a_en: "Yes, designed for this stage after assessment." }
    ],
    patient_story: { quote_ar: "بعد الولادة استعدت شعري بهدوء، دون وعود كبيرة.",
                     quote_en: "After my pregnancy I got my hair back — quietly, with no big promises.",
                     initials: "N.S.", year: "2024" }
  },
  {
    slug: "8-week-sculpt", position: 5, persona: "maintain", codeword: "SCULPT",
    name_ar: "نحت الثمانية أسابيع", name_en: "8-Week Sculpt",
    promise_ar: "نحت الجسم، للقوام والقوة والقوام المعتدل.",
    promise_en: "Body contour, for tone, strength and posture.",
    duration_ar: "٨ أسابيع", duration_en: "8 weeks",
    meta_ar: "٨ أسابيع · الجسم", meta_en: "8 weeks · Body",
    who_for_ar: "لمن تريد تحسين القوام والقوة دون ضجيج.",
    who_for_en: "For tone and strength, without the noise.",
    scope_ar: "بروتوكول مكثّف على ٨ أسابيع للقوام وشدّ الجسم.",
    scope_en: "An intensive 8-week protocol for tone and body firming.",
    excludes_ar: "ليس بديلًا عن إنقاص الوزن الطبي.", excludes_en: "Not a substitute for medical weight loss.",
    stages: [
      { week_ar: "الأسابيع ١–٤", week_en: "Weeks 1–4", title_ar: "التفعيل", title_en: "Activate",
        body_ar: "تفعيل العضلات وشدّ الأنسجة.", body_en: "Muscle activation and tissue firming." },
      { week_ar: "الأسابيع ٥–٨", week_en: "Weeks 5–8", title_ar: "النحت", title_en: "Sculpt",
        body_ar: "تحديد القوام وتثبيت النتائج.", body_en: "Definition and results locked in." }
    ],
    faqs: [
      { q_ar: "كم جلسة في الأسبوع؟", q_en: "How many sessions per week?",
        a_ar: "يُحدّد عددها بعد التقييم، عادةً جلستان.", a_en: "Set after assessment, usually two." }
    ],
    patient_story: { quote_ar: "شعرت بالفرق في قوّتي قبل أن أراه في المرآة.",
                     quote_en: "I felt the difference in my strength before I saw it in the mirror.",
                     initials: "S.D.", year: "2025" }
  },
  {
    slug: "skin-insider", position: 6, persona: "maintain", codeword: "INSIDER",
    name_ar: "عضوية المطّلعات", name_en: "Skin Insider Membership",
    promise_ar: "عناية هادئة ومستمرة، للمريضات على المدى الطويل.",
    promise_en: "Quiet maintenance, for long-term patients.",
    duration_ar: "سنوية", duration_en: "Annual",
    meta_ar: "سنوية · العناية المستمرة", meta_en: "Annual · Maintenance",
    who_for_ar: "لمن أكملت بروتوكولها وتريد الحفاظ على نتائجها.",
    who_for_en: "For those who have completed a protocol and want to maintain it.",
    scope_ar: "عضوية سنوية بمراجعات منتظمة وأولوية في المواعيد.",
    scope_en: "An annual membership with regular reviews and priority scheduling.",
    excludes_ar: "لا تشمل البروتوكولات العلاجية الجديدة دون تقييم.",
    excludes_en: "Does not include new treatment protocols without assessment.",
    stages: [
      { week_ar: "ربع سنوي", week_en: "Quarterly", title_ar: "المراجعة", title_en: "Review",
        body_ar: "مراجعة منتظمة لحالة البشرة.", body_en: "A regular review of your skin." }
    ],
    faqs: [
      { q_ar: "هل يمكنني الانضمام دون بروتوكول سابق؟", q_en: "Can I join without a prior protocol?",
        a_ar: "نوصي بالبدء بتقييم منهج ميساء أولًا.", a_en: "We recommend beginning with the Maysa Method assessment first." }
    ],
    patient_story: { quote_ar: "أصبحت العناية ببشرتي عادة هادئة، لا مهمة.",
                     quote_en: "Caring for my skin became a quiet habit, not a task.",
                     initials: "H.M.", year: "2024" }
  }
]

protocols.each do |attrs|
  Protocol.find_or_initialize_by(slug: attrs[:slug]).update!(attrs)
end

puts "Seeded #{Protocol.count} protocols."
