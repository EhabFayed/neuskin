# The three launch patient stories — previously the stories/story_items
# section keys. Idempotent by quote_en.
STORY_SEEDS = [
  {
    position: 1,
    intro_en: "She came in tired of being sold to. What she wanted was a plan.",
    intro_ar: "جاءت وقد سئمت من محاولات البيع. كل ما أرادته هو خطة.",
    quote_en: "For the first time, someone told me what not to do. That's when I trusted them.",
    quote_ar: "لأول مرة، أخبرني أحد بما لا يجب أن أفعله. عندها وثقت بهم.",
    protocol_line_en: "Diagnostic Foundation → Skin",
    protocol_line_ar: "التقييم التأسيسي ← البشرة",
    close_en: "Twelve months on, her routine is shorter and her skin is steadier than it has been in years.",
    close_ar: "بعد اثني عشر شهرًا، أصبح روتينها أقصر وبشرتها أكثر ثباتًا مما كانت عليه منذ سنوات.",
    byline_en: "L.M. · 34 · Riyadh", byline_ar: "ل.م. · ٣٤ · الرياض"
  },
  {
    position: 2,
    intro_en: "A bride with six months and a quiet kind of panic.",
    intro_ar: "عروس أمامها ستة أشهر، ونوعٌ هادئ من القلق.",
    quote_en: "No one promised me a miracle. They promised me a calendar, and they kept it.",
    quote_ar: "لم يعدني أحد بمعجزة. وعدوني بجدولٍ زمني، والتزموا به.",
    protocol_line_en: "The Bride's 180", protocol_line_ar: "عروس الـ١٨٠",
    close_en: "She walked into her wedding without a single last-minute treatment — everything had been sequenced months earlier.",
    close_ar: "دخلت حفل زفافها دون علاجٍ واحد في اللحظة الأخيرة — كل شيء كان قد رُتِّب قبل أشهر.",
    byline_en: "A.R. · 29 · Jeddah", byline_ar: "أ.ر. · ٢٩ · جدة"
  },
  {
    position: 3,
    intro_en: "Long-term maintenance, on her own terms.",
    intro_ar: "عناية طويلة الأمد، بشروطها هي.",
    quote_en: "I review my skin like I review anything that matters to me — with data, every quarter.",
    quote_ar: "أراجع بشرتي كما أراجع كل ما يهمّني — بالبيانات، كل ثلاثة أشهر.",
    protocol_line_en: "Private Care", protocol_line_ar: "الرعاية الخاصة",
    close_en: "Three years in, the relationship is the treatment. Small adjustments, reviewed often, nothing overdone.",
    close_ar: "بعد ثلاث سنوات، أصبحت العلاقة هي العلاج. تعديلات صغيرة، تُراجَع باستمرار، دون أي مبالغة.",
    byline_en: "F.K. · 41 · Riyadh", byline_ar: "ف.ك. · ٤١ · الرياض"
  }
].freeze

created = 0
STORY_SEEDS.each do |attrs|
  next if Story.exists?(quote_en: attrs[:quote_en])

  Story.create!(attrs)
  created += 1
end
puts "Seeded #{created} stories." if created.positive?
