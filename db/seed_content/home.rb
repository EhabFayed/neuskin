# Home page content seed.
#
# EN/AR values reflect the content team's approved copy
# ("NeuSkin Website content.pdf", July 2026). Where the PDF gave no Arabic,
# ar: stays blank and the page falls back to English on the AR locale.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("home", [
    {
      kind: "home_hero", label: "Hero — top of page", position: 0,
      contents: [
        { key: "eyebrow",    label: "Eyebrow (small line above headline)",
          en: "Doctor-led · Riyadh", ar: "بإشراف طبيبة · الرياض" },
        # Hero runs as two lines (dashboard edit, "heros" commit) — line 3 empty.
        { key: "headline_1", label: "Headline line 1",
          en: "Medical Precision.", ar: "دقةُ الطب،" },
        { key: "headline_2", label: "Headline line 2",
          en: "Aesthetic Grace.", ar: "ورقيُّ الجمال." },
        { key: "headline_3", label: "Headline line 3 (emphasis)",
          en: "", ar: "" },
        { key: "sub",        label: "Sub-text under headline",
          en: "Riyadh's doctor-led skin intelligence clinic. Where your aesthetic journey is guided by expert care, subtle results, and absolute privacy.",
          ar: "وجهتُكِ في الرياض للعناية بالبشرة تحت إشرافٍ طبيٍّ متخصص؛ حيثُ نمنحُكِ جمالاً طبيعياً هادئاً، يضعُ خصوصيتكِ وراحتكِ في المقدمة." },
        { key: "foot_1",     label: "Footer note 1",
          en: "Est. Al Malqa · Riyadh", ar: "تأسست في الملقا · الرياض" },
        { key: "foot_2",     label: "Footer note 2",
          en: "Six protocols · one philosophy", ar: "ستة بروتوكولات · فلسفة واحدة" }
      ]
    },
    {
      kind: "home_principles", label: "Three principles", position: 1,
      contents: [
        { key: "eyebrow",   label: "Eyebrow",
          en: "The Promise", ar: "" },
        { key: "title",     label: "Heading",
          en: "Three pillars of our promise.", ar: "ثلاثةُ وعود نلتزمُ بها بدقة." },
        { key: "p1_num",    label: "Principle 1 — number/label",
          en: "01 — Principle", ar: "" },
        { key: "p1_title",  label: "Principle 1 — title",
          en: "Doctor-led", ar: "قيادة طبية" },
        { key: "p1_body",   label: "Principle 1 — body",
          en: "Every plan is designed by our medical team — never assembled from a treatment menu. You meet a clinician first, and a recommendation second.",
          ar: "لا نعتمدُ أبداً على قوائمَ جاهزة؛ كلُّ خطةٍ علاجيةٍ يُصممها فريقُنا الطبي خصيصاً لكِ. تلتقينَ بالمتخصصين أولاً، لنرسمَ معاً الطريقَ الأنسب لجمالك." },
        { key: "p2_num",    label: "Principle 2 — number/label",
          en: "02 — Principle", ar: "" },
        { key: "p2_title",  label: "Principle 2 — title",
          en: "Discreet", ar: "خصوصيةٍ تامة" },
        { key: "p2_body",   label: "Principle 2 — body",
          en: "Private consultation. Private treatment. Private results. Your name never leaves the room, and your file never leaves the clinic.",
          ar: "استشارةٌ خاصة، جلسةٌ خاصة، ونتائجُ لكِ وحدك. اسمكِ لا يغادرُ غرفتنا، وملفُّكِ لا يخرجُ من عيادتنا." },
        { key: "p3_num",    label: "Principle 3 — number/label",
          en: "03 — Principle", ar: "" },
        { key: "p3_title",  label: "Principle 3 — title",
          en: "Measured", ar: "نتائجَ مدروسة" },
        { key: "p3_body",   label: "Principle 3 — body",
          en: "Outcomes documented every quarter. No guesswork, no theatre — only what the skin shows when we compare it to where it began.",
          ar: "نُوَثِّقُ تقدّمكِ كلَّ ربعِ سنة. بلا افتراضات أو مبالغات، نعتمدُ فقط على حالة بشرتكِ عند مقارنتها ببدايةِ رحلتكِ معنا." }
      ]
    },
    {
      # July 2026 deck: retitled "About NeuSkin", third-person copy, AR added.
      kind: "home_founder", label: "About NeuSkin", position: 2,
      contents: [
        { key: "eyebrow", label: "Eyebrow",
          en: "About NeuSkin", ar: "عن نيوسكن" },
        { key: "body_1",  label: "Body paragraph 1",
          en: "NeuSkin was founded to move beyond the noise of mass-market beauty. We believe in a medical approach that values your time and trust above all else. Every woman deserves clarity, a bespoke plan, and results that honor her natural beauty, guided by patience and clinical expertise.",
          ar: "تأسست 'نيوسكن' لتكون صوتاً مختلفاً يبتعد عن صخب التجميل التقليدي. نحن نؤمن بنهجٍ طبي يضع وقتك وثقتك فوق كل اعتبار؛ فكل امرأة تستحق الوضوح، وخطةً صُممت خصيصاً لها، ونتائجَ تُكرم جمالها الطبيعي بلمسةٍ تجمع بين الصبرِ والخبرة." },
        { key: "body_2",  label: "Body paragraph 2",
          en: "Our journey begins with a deep, intuitive understanding of your skin. Together, we prioritize what truly serves your long-term health, leaving behind the trends that don't.",
          ar: "رحلتنا معك تبدأ بفهمٍ حقيقي لطبيعة بشرتك واحتياجاتها الفعلية. معاً، نضع الأولوية لكل ما يخدم صحة جمالك على المدى الطويل، متجاوزين كل الصيحات المؤقتة التي لا تضيف لمستقبلك شيئاً." },
        { key: "sign",    label: "Signature",
          en: "", ar: "" },
        { key: "link",    label: "Link text",
          en: "Read her philosophy →", ar: "" }
      ]
    },
    {
      kind: "home_protocols", label: "Six protocols — heading", position: 3,
      contents: [
        { key: "eyebrow",  label: "Eyebrow",
          en: "The Six Protocols", ar: "" },
        { key: "title",    label: "Heading",
          en: "Six protocols.", ar: "ستةُ بروتوكولات." },
        { key: "title_em", label: "Heading (emphasis)",
          en: "One philosophy.", ar: "فلسفةٌ واحدة." },
        { key: "link",     label: "Link text",
          en: "View all protocols →", ar: "" }
      ]
    },
    {
      kind: "home_clinic", label: "Inside the clinic (hscroll)", position: 4,
      contents: [
        { key: "eyebrow",     label: "Eyebrow",
          en: "Inside NeuSkin", ar: "" },
        { key: "title",       label: "Heading",
          en: "Designed for quiet,", ar: "صُممت للهدوء،" },
        { key: "title_em",    label: "Heading (emphasis)",
          en: "defined by privacy.", ar: "وتميزها الخصوصية." },
        { key: "lead",        label: "Lead paragraph",
          en: "Beyond the clinic doors in Al Malqa, privacy is our first protocol. Experience a sanctuary crafted for your comfort, at your own pace.",
          ar: "خلفَ أبوابِ عيادتنا في حي الملقا، الخصوصيةُ هي بروتوكولنا الأول. استمتعي بمساحةٍ صُممت لراحتك، وبوتيرةٍ تليقُ بك." },
        { key: "cue",         label: "Scroll cue",
          en: "Scroll →", ar: "" },
        { key: "cap_1",       label: "Photo caption 1",
          en: "01 · Treatment room", ar: "01 · غرفة الإجراءات" },
        { key: "cap_2",       label: "Photo caption 2",
          en: "02 · The lounge", ar: "02 · صالة الاستقبال" },
        { key: "cap_3",       label: "Photo caption 3",
          en: "03 · Device room", ar: "03 · غرفة الأجهزة" },
        { key: "cap_4",       label: "Photo caption 4",
          en: "04 · In the detail", ar: "04 · في التفاصيل" },
        { key: "cap_5",       label: "Photo caption 5",
          en: "05 · The entrance", ar: "05 · المدخل" },
        { key: "quote",       label: "Closing quote",
          en: "“A clinic should be measured by what it refuses to do.”", ar: "" },
        { key: "outro_link",  label: "Outro link text",
          en: "Tour the clinic →", ar: "" }
      ]
    },
    {
      # Section kept in the CMS but currently hidden on the public page —
      # the content team asked to remove it until real, consented patient
      # reviews are available (see home.html.erb).
      kind: "home_quotes", label: "Testimonials (hidden)", position: 5,
      contents: [
        { key: "eyebrow", label: "Eyebrow",
          en: "In their words", ar: "" },
        { key: "quote_1", label: "Quote 1 — text",
          en: "She told me what I didn't need before she told me what I did. I'd never had a doctor do that.",
          ar: "" },
        { key: "by_1",    label: "Quote 1 — attribution",
          en: "L.M. · Riyadh", ar: "" },
        { key: "quote_2", label: "Quote 2 — text",
          en: "Six months, one plan, reviewed every quarter. My skin looks like mine — only rested.",
          ar: "" },
        { key: "by_2",    label: "Quote 2 — attribution",
          en: "A.R. · Riyadh", ar: "" },
        { key: "quote_3", label: "Quote 3 — text",
          en: "Discreet from the first message to the last review. I never felt like a number on a calendar.",
          ar: "" },
        { key: "by_3",    label: "Quote 3 — attribution",
          en: "F.K. · Riyadh", ar: "" }
      ]
    },
    {
      kind: "home_cta", label: "Closing CTA band", position: 6,
      contents: [
        { key: "title",    label: "Heading",
          en: "Quietly bespoke.", ar: "رفاهيةٌ تليقُ بكِ." },
        { key: "title_em", label: "Heading (emphasis)",
          en: "Begin your journey with a personal dialogue.", ar: "ابدئي رحلتكِ بحديثٍ استثنائي." },
        { key: "body",     label: "Body text",
          en: "A personal inquiry is all it takes to start. We are here to listen, guide, and respond to your needs, personally, from Saturday to Thursday.",
          ar: "ندركُ أنَّ الخطوةَ الأولى تبدأُ بحديثٍ خاص. نحن هنا لنستمعَ إليكِ ونرسمَ لكِ المسارَ الأنسب، بكلِّ اهتمامٍ، من السبتِ إلى الخميس." },
        { key: "cta",      label: "Button label",
          en: "Secure your private consultation", ar: "احجزي استشارتكِ الخاصة" },
        { key: "sign",     label: "Signature",
          en: "— The NeuSkin Team", ar: "— فريق نيوسكن" }
      ]
    }
  ])
