# The nine launch FAQ entries — previously the faq/faq_items section keys.
# Idempotent by question_en.
FAQ_SEEDS = [
  { category: "before_you_come_in", position: 1,
    question_en: "Do you publish a price list?", question_ar: "هل تنشرون قائمة أسعار؟",
    answer_en: "No. Care is arranged by consultation, never sold from a menu. We discuss investment privately once we understand what your skin actually needs.",
    answer_ar: "لا. الرعاية تُرتَّب عبر الاستشارة، ولا تُباع أبدًا من قائمة. نناقش التكلفة بخصوصية بعد أن نفهم ما تحتاجه بشرتك فعلًا." },
  { category: "before_you_come_in", position: 2,
    question_en: "How do I start?", question_ar: "كيف أبدأ؟",
    answer_en: "Send a private inquiry — on WhatsApp or through the form. Dr. Maysa or our patient relations lead reviews every message personally.",
    answer_ar: "أرسلي استفسارًا خاصًا — عبر واتساب أو من خلال النموذج. تُراجع د. ميساء أو مسؤولة علاقات المريضات كل رسالة شخصيًا." },
  { category: "before_you_come_in", position: 3,
    question_en: "Is the first visit a treatment?", question_ar: "هل الزيارة الأولى علاج؟",
    answer_en: "No. The first appointment is a doctor-led diagnostic assessment. Nothing is performed; we read your skin and write a plan.",
    answer_ar: "لا. الموعد الأول تقييم تشخيصي بإشراف الطبيبة. لا يُجرى فيه أي إجراء؛ نقرأ بشرتك ونكتب الخطة." },
  { category: "how_care_works", position: 1,
    question_en: "Why a twelve-month plan?", question_ar: "لماذا خطة من اثني عشر شهرًا؟",
    answer_en: "Good skin is sequenced over time, not forced in a single session. We plan across quarters and review the results every three months.",
    answer_ar: "البشرة الجميلة تُبنى بالتدرّج عبر الوقت، لا تُفرَض في جلسة واحدة. نخطّط على أرباع السنة ونراجع النتائج كل ثلاثة أشهر." },
  { category: "how_care_works", position: 2,
    question_en: "Will I see Dr. Maysa herself?", question_ar: "هل سأقابل د. ميساء بنفسها؟",
    answer_en: "Your initial assessment is conducted personally by Dr. Maysa. Ongoing care may involve the wider medical team, always under her direction.",
    answer_ar: "تقييمك الأول تُجريه د. ميساء شخصيًا. وقد تشمل الرعاية اللاحقة الفريق الطبي الأوسع، دائمًا تحت إشرافها." },
  { category: "how_care_works", position: 3,
    question_en: "What if a treatment isn't right for me?", question_ar: "وماذا لو لم يكن العلاج مناسبًا لي؟",
    answer_en: "Then we say so. Turning something down is part of the practice — we would rather keep your trust than sell you a session.",
    answer_ar: "عندها نقولها بصراحة. رفض ما لا يناسبك جزء من ممارستنا — نفضّل أن نحفظ ثقتك على أن نبيعك جلسة." },
  { category: "privacy", position: 1,
    question_en: "How private is my information?", question_ar: "ما مدى خصوصية معلوماتي؟",
    answer_en: "Your inquiry is seen only by our patient relations lead and Dr. Maysa. We are PDPL compliant and store data securely.",
    answer_ar: "لا يطّلع على استفسارك سوى مسؤولة علاقات المريضات ود. ميساء. نلتزم بنظام حماية البيانات الشخصية (PDPL) ونحفظ بياناتك بأمان." },
  { category: "privacy", position: 2,
    question_en: "Do you photograph patients?", question_ar: "هل تلتقطون صورًا للمريضات؟",
    answer_en: "Only with separate, specific, written consent. Consent is never assumed and can be withdrawn at any time.",
    answer_ar: "فقط بموافقة خطية منفصلة ومحددة. الموافقة لا تُفترَض أبدًا، ويمكن سحبها في أي وقت." },
  { category: "privacy", position: 3,
    question_en: "Where are you, and when are you open?", question_ar: "أين تقعون، ومتى تفتحون؟",
    answer_en: "Al Malqa, Riyadh. Saturday to Thursday, 10:00–22:00. Friday closed. The exact address is shared when we schedule.",
    answer_ar: "الملقا، الرياض. من السبت إلى الخميس، ١٠:٠٠–٢٢:٠٠. الجمعة مغلق. نشارك العنوان الدقيق عند تحديد الموعد." }
].freeze

created = 0
FAQ_SEEDS.each do |attrs|
  next if Faq.exists?(question_en: attrs[:question_en])

  Faq.create!(attrs)
  created += 1
end
puts "Seeded #{created} FAQs." if created.positive?
