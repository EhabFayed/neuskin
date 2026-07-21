# The four launch team members — the values that previously lived in the
# the_team/team_members section keys, as records. Idempotent by name_en.
# The founder entry was removed with the site-wide Maysa replacement
# (July 2026) — the team now leads with the practising physicians.
TEAM_SEEDS = [
  {
    position: 2,
    name_en: "Dr. Lina Haddad", name_ar: "د. لينا حدّاد",
    role_en: "Senior Aesthetic Physician", role_ar: "طبيبة تجميل أولى",
    cred_en: "MBBS · Diploma in Aesthetic Medicine",
    cred_ar: "بكالوريوس الطب والجراحة · دبلوم طب التجميل",
    focus_en: "Injectables & restraint", focus_ar: "الحقن وضبط النفس",
    bio_en: "Lina executes the plan with a light hand. Her reputation is built less on what she does than on what she declines to do — and patients trust her for exactly that.",
    bio_ar: "تنفّذ لينا الخطة بيدٍ خفيفة. سمعتها لم تُبنَ على ما تفعله بقدر ما بُنيت على ما ترفض أن تفعله — ولهذا بالضبط تثق بها المريضات."
  },
  {
    position: 3,
    name_en: "Dr. Sara Othman", name_ar: "د. سارة عثمان",
    role_en: "Dermatology Associate", role_ar: "طبيبة أمراض جلدية مشاركة",
    cred_en: "MBBS · Clinical Dermatology",
    cred_ar: "بكالوريوس الطب والجراحة · الأمراض الجلدية السريرية",
    focus_en: "Skin barrier & pigment", focus_ar: "حاجز البشرة والتصبّغ",
    bio_en: "Sara handles the slow, unglamorous work that good skin actually depends on — barrier repair, pigment correction, and the careful sequencing that holds results over months.",
    bio_ar: "تتولّى سارة العمل الهادئ البعيد عن الأضواء الذي تقوم عليه البشرة الجميلة فعلًا — ترميم الحاجز الواقي، وتصحيح التصبّغ، والتدرّج الدقيق الذي يحفظ النتائج عبر الشهور."
  },
  {
    position: 4,
    name_en: "Noor Al-Fahad", name_ar: "نور الفهد",
    role_en: "Patient Relations Lead", role_ar: "مسؤولة علاقات المريضات",
    cred_en: "First point of contact · privacy-trained",
    cred_ar: "أول جهة تواصل · مدرَّبة على حماية الخصوصية",
    focus_en: "Discretion & continuity", focus_ar: "السرّية والاستمرارية",
    bio_en: "Noor reads every inquiry personally and protects each patient's privacy from the first message to the last review. Nothing reaches the clinic floor that she has not handled with care.",
    bio_ar: "تقرأ نور كل استفسار بنفسها، وتحمي خصوصية كل مريضة من أول رسالة حتى آخر مراجعة. لا يصل شيء إلى العيادة إلا وقد مرّ بعنايتها."
  }
].freeze

created = 0
TEAM_SEEDS.each do |attrs|
  next if TeamMember.exists?(name_en: attrs[:name_en])

  TeamMember.create!(attrs)
  created += 1
end
puts "Seeded #{created} team members." if created.positive?
