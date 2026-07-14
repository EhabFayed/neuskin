# Journal posts — the six editorial pieces from the original design mockup,
# now real Blog records (bilingual, published). Idempotent by slug: existing
# posts are left untouched so admin edits survive reseeding.
BLOG_SEEDS = [
  {
    slug_en: "why-i-read-skin-before-i-treat-it",
    slug_ar: "لماذا-أقرأ-البشرة-قبل-أن-أعالجها",
    category: "maysa_writes",
    title_en: "Why I read skin before I treat it",
    title_ar: "لماذا أقرأ البشرة قبل أن أعالجها",
    excerpt_en: "The first appointment is diagnostic, never cosmetic. Here is what we are actually measuring, and why the order matters.",
    excerpt_ar: "الموعد الأول تشخيصي، لا تجميلي أبدًا. إليك ما نقيسه فعلًا، ولماذا يهمّ الترتيب.",
    paragraphs: [
      ["Most clinics begin with the treatment. We begin with the reading. Before anything touches your skin, we document its baseline — barrier, tone, texture, pigment — because a plan written without a baseline is a guess wearing a lab coat.",
       "تبدأ معظم العيادات بالعلاج. ونحن نبدأ بالقراءة. قبل أن يلمس بشرتك أي شيء، نوثّق خط أساسها — الحاجز واللون والملمس والتصبّغ — لأن خطةً تُكتب دون خط أساس ليست سوى تخمينٍ يرتدي معطفًا أبيض."],
      ["The reading decides the order, and the order decides the result. A barrier that is not ready will waste the best treatment in the world; pigment corrected before the cause is addressed simply returns. We sequence, we do not stack.",
       "القراءة تقرّر الترتيب، والترتيب يقرّر النتيجة. الحاجز غير الجاهز سيُهدر أفضل علاج في العالم؛ والتصبّغ الذي يُصحَّح قبل معالجة سببه يعود ببساطة. نحن نرتّب الخطوات، ولا نكدّسها."],
      ["This is why your first visit ends with a written plan and not a procedure. You leave knowing what your skin needs, in what order, and — just as important — what it does not need at all.",
       "لهذا تنتهي زيارتك الأولى بخطة مكتوبة لا بإجراء. تغادرين وأنتِ تعرفين ما تحتاجه بشرتك، وبأي ترتيب، والأهم من ذلك — ما لا تحتاجه إطلاقًا."]
    ]
  },
  {
    slug_en: "a-quiet-room-by-design",
    slug_ar: "غرفة-هادئة-عن-قصد",
    category: "inside_clinic",
    title_en: "A quiet room, by design",
    title_ar: "غرفة هادئة، عن قصد",
    excerpt_en: "We built Al Malqa around discretion — separate entries, no waiting room theatre, one patient at a time.",
    excerpt_ar: "بنينا عيادة الملقا حول الخصوصية — مداخل منفصلة، لا مسرح في غرفة الانتظار، ومريضة واحدة في كل مرة.",
    paragraphs: [
      ["Privacy is not a policy here; it is the floor plan. The clinic was drawn so that two patients need never cross paths — separate entries, a private suite, appointments spaced so the corridor stays empty.",
       "الخصوصية هنا ليست سياسة مكتوبة؛ بل هي مخطط المبنى نفسه. رُسمت العيادة بحيث لا تلتقي مريضتان أبدًا — مداخل منفصلة، وجناح خاص، ومواعيد متباعدة تُبقي الممر خاليًا."],
      ["There is no waiting room theatre because there is barely a waiting room. You arrive, you are received, you are seen. The quiet is not an aesthetic choice — it is what allows an honest conversation about your skin.",
       "لا مسرح في غرفة الانتظار لأنه لا تكاد توجد غرفة انتظار. تصلين، فتُستقبلين، فتُقابَلين. الهدوء ليس خيارًا جماليًا — بل هو ما يسمح بحديثٍ صادق عن بشرتك."],
      ["Your file never leaves the clinic, and your name never leaves the room. That was the brief we gave the architects, and it is the promise we keep every day since.",
       "ملفّك لا يغادر العيادة، واسمك لا يغادر الغرفة. كان هذا ما طلبناه من المعماريين، وهو الوعد الذي نحفظه كل يوم منذ ذلك الحين."]
    ]
  },
  {
    slug_en: "the-three-products-most-skin-actually-needs",
    slug_ar: "المنتجات-الثلاثة-التي-تحتاجها-بشرتك",
    category: "ritual",
    title_en: "The three products most skin actually needs",
    title_ar: "المنتجات الثلاثة التي تحتاجها معظم البشرات فعلًا",
    excerpt_en: "Restraint is the most underrated skill in skincare. A short list, and the reasoning behind each choice.",
    excerpt_ar: "ضبط النفس هو المهارة الأكثر استهانةً بها في العناية بالبشرة. قائمة قصيرة، والمنطق وراء كل خيار.",
    paragraphs: [
      ["Walk into any pharmacy and you will find forty steps for a routine that needs three: a cleanser that respects the barrier, a treatment chosen for your actual concern, and sunscreen worn like a habit, not an occasion.",
       "ادخلي أي صيدلية وستجدين أربعين خطوة لروتينٍ لا يحتاج سوى ثلاث: غسول يحترم حاجز البشرة، ومستحضر علاجي يُختار لمشكلتك الحقيقية، وواقٍ من الشمس يُلبس كعادةٍ لا كمناسبة.",],
      ["Every additional product is a variable, and every variable makes your skin harder to read. When a routine is short, we can tell what is working. When it is long, nobody can — including the person selling it.",
       "كل منتج إضافي متغيّر جديد، وكل متغيّر يجعل بشرتك أصعب قراءة. حين يكون الروتين قصيرًا، نستطيع أن نعرف ما الذي يعمل. وحين يطول، لا أحد يستطيع — بمن في ذلك من يبيعه."],
      ["The third product is the one most often skipped and least negotiable. Sunscreen is not a summer product; it is the quiet foundation every other result stands on.",
       "المنتج الثالث هو الأكثر إهمالًا والأقل قابلية للتفاوض. واقي الشمس ليس منتجًا صيفيًا؛ بل هو الأساس الهادئ الذي تقوم عليه كل نتيجة أخرى."]
    ]
  },
  {
    slug_en: "sequencing-the-year-not-the-session",
    slug_ar: "التسلسل-السنة-لا-الجلسة",
    category: "maysa_writes",
    title_en: "Sequencing: the year, not the session",
    title_ar: "التسلسل: السنة لا الجلسة",
    excerpt_en: "Good skin is built across quarters. How we plan twelve months so nothing is ever overwhelmed.",
    excerpt_ar: "البشرة الجميلة تُبنى عبر أرباع السنة. هكذا نخطّط اثني عشر شهرًا حتى لا يُرهَق شيء أبدًا.",
    paragraphs: [
      ["A session flatters; a sequence transforms. The skin renews on its own calendar — roughly a month per cycle — and a plan that ignores that calendar is asking biology to hurry, which it never does.",
       "الجلسة تُجامل؛ أما التسلسل فيُحوِّل. تتجدد البشرة وفق تقويمها الخاص — دورة كل شهر تقريبًا — والخطة التي تتجاهل هذا التقويم تطلب من البيولوجيا أن تستعجل، وهي لا تفعل أبدًا.",],
      ["We plan in quarters. The first restores the foundation, the second corrects, the third builds, the fourth maintains. Each quarter closes with a review against your baseline photos — data, not memory.",
       "نخطّط بأرباع السنة. الأول يستعيد الأساس، والثاني يصحّح، والثالث يبني، والرابع يحافظ. وكل ربعٍ يُختم بمراجعة مقارنةً بصور خط الأساس — بيانات، لا ذاكرة."],
      ["The result of a year planned this way rarely photographs like a transformation, and that is the point. You simply look like yourself — consistently, in every light, without a story to explain.",
       "نتيجة سنةٍ خُطّط لها بهذه الطريقة نادرًا ما تبدو في الصور تحوّلًا دراميًا، وهذا هو المقصود. تبدين نفسك ببساطة — بثبات، في كل إضاءة، دون قصة تحتاج شرحًا."]
    ]
  },
  {
    slug_en: "what-changed-was-how-i-felt-walking-in",
    slug_ar: "ما-تغير-هو-شعوري-وأنا-أدخل",
    category: "patient_notes",
    title_en: "What changed was how I felt walking in",
    title_ar: "ما تغيّر هو شعوري وأنا أدخل",
    excerpt_en: "A patient on the difference between being sold to and being cared for — shared, with consent.",
    excerpt_ar: "مريضة تروي الفرق بين أن يُباع لك شيء وأن يُعتنى بك — نُشرت بموافقتها.",
    paragraphs: [
      ["“I had been to enough clinics to know the script. You sit down, you name one concern, and you leave with a quote for five treatments. I walked into NeuSkin braced for the same conversation.”",
       "«زرتُ من العيادات ما يكفي لأحفظ السيناريو. تجلسين، تذكرين مشكلة واحدة، وتخرجين بعرض سعرٍ لخمسة علاجات. دخلتُ نيو سكين وأنا متحفّزة للحوار نفسه.»"],
      ["“Instead, the first thing Dr. Maysa did was tell me what I did not need. She crossed two things off my own list. I remember thinking: she just talked herself out of money — and talked me into trust.”",
       "«بدلًا من ذلك، كان أول ما فعلته د. ميساء أن أخبرتني بما لا أحتاجه. شطبت أمرين من قائمتي أنا. أذكر أنني فكّرت: لقد تخلّت للتو عن مالٍ كان سيصلها — وكسبت ثقتي.»"],
      ["“The results came, quietly, over months. But what changed first was how I felt walking in: not like a customer, like a patient. That difference is the whole clinic.”",
       "«جاءت النتائج بهدوء، على مدى شهور. لكن ما تغيّر أولًا هو شعوري وأنا أدخل: لست زبونة، بل مريضة. هذا الفرق هو العيادة كلها.»"]
    ]
  },
  {
    slug_en: "how-we-say-no",
    slug_ar: "كيف-نقول-لا",
    category: "inside_clinic",
    title_en: "How we say no",
    title_ar: "كيف نقول لا",
    excerpt_en: "Turning a treatment down is part of the practice. The conversations we have when something isn't right for you.",
    excerpt_ar: "رفض العلاج جزء من ممارستنا. هذه هي الحوارات التي نجريها حين لا يكون شيء ما مناسبًا لك.",
    paragraphs: [
      ["Some of the most important work in this clinic is the work we decline. A treatment that is fashionable but wrong for your skin, a timeline that cannot be done safely, a result that would not look like you.",
       "بعض أهم ما نقوم به في هذه العيادة هو ما نرفض القيام به. علاجٌ رائج لكنه خاطئ لبشرتك، أو جدول زمني لا يمكن إنجازه بأمان، أو نتيجة لن تشبهك."],
      ["Saying no is a clinical skill, and we practise it the way we practise everything else: with a reason you can understand. We will always tell you what we would do instead, and when — or whether — the answer might change.",
       "قول «لا» مهارة سريرية، ونمارسها كما نمارس كل شيء آخر: بسببٍ يمكنك فهمه. سنخبرك دائمًا بما سنفعله بدلًا من ذلك، ومتى — أو إن كان — الجواب قد يتغيّر."],
      ["Patients sometimes leave that conversation without an appointment. Most come back, precisely because the door they walked out of was honest with them.",
       "تغادر بعض المريضات ذلك الحوار دون حجز موعد. لكن معظمهن يعدن، تحديدًا لأن الباب الذي خرجن منه كان صادقًا معهن."]
    ]
  }
].freeze

blog_count = 0
BLOG_SEEDS.each do |seed|
  next if Blog.exists?(slug_en: seed[:slug_en])

  blog = Blog.new(seed.except(:paragraphs).merge(is_published: true))
  seed[:paragraphs].each_with_index do |(en, ar), i|
    blog.contents.build(key: "para_#{i + 1}", position: i + 1, value_en: en, value_ar: ar)
  end
  blog.save!
  blog_count += 1
end
puts "Seeded #{blog_count} journal posts." if blog_count.positive?
