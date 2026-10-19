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
          en: "Doctor-led · Riyadh", ar: "" },
        # Hero runs as two lines (dashboard edit, "heros" commit) — line 3 empty.
        { key: "headline_1", label: "Headline line 1",
          en: "Medical Precision.", ar: "أفضل عيادة تجميل بالرياض |" },
        { key: "headline_2", label: "Headline line 2",
          en: "Aesthetic Grace.", ar: "عيادة نيوسكين" },
        { key: "headline_3", label: "Headline line 3 (emphasis)",
          en: "", ar: "" },
        { key: "sub",        label: "Sub-text under headline",
          en: "Riyadh's doctor-led skin intelligence clinic. Where your aesthetic journey is guided by expert care, subtle results, and absolute privacy.",
          ar: "أفضل عيادة تجميل متكاملة في الرياض للعناية بالبشرة تحت إشراف طبي متخصص؛ نضمن لكِ نتائج مدروسة تبرز جمالكِ الطبيعي وسط بيئة تضمن خصوصيتكِ وراحتكِ أولاً." },
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
          en: "Three pillars of our promise.", ar: "لماذا تختارين عيادة نيوسكن" },
        { key: "p1_num",    label: "Principle 1 — number/label",
          en: "01 — Principle", ar: "" },
        { key: "p1_title",  label: "Principle 1 — title",
          en: "Doctor-led", ar: "قيادة طبية بخطط مخصصة" },
        { key: "p1_body",   label: "Principle 1 — body",
          en: "Every plan is designed by our medical team — never assembled from a treatment menu. You meet a clinician first, and a recommendation second.",
          ar: "في نيوسكن، تبدأ رحلتكِ بتقييم متخصص لفهم احتياجات بشرتكِ، ثم نساعدكِ في اختيار الإجراءات المناسبة لكِ ضمن خطة عناية مخصصة، لأن كل بشرة لها احتياجاتها الخاصة." },
        { key: "p2_num",    label: "Principle 2 — number/label",
          en: "02 — Principle", ar: "" },
        { key: "p2_title",  label: "Principle 2 — title",
          en: "Discreet", ar: "خصوصية تامة في كل خطوة" },
        { key: "p2_body",   label: "Principle 2 — body",
          en: "Private consultation. Private treatment. Private results. Your name never leaves the room, and your file never leaves the clinic.",
          ar: "في عيادة تجميل للبشرة بنيوسكن، تبدأ رحلتكِ بتقييم متخصص لفهم احتياجات بشرتكِ، وتصميم خطة عناية تناسبكِ، لتكون كل خطوة مبنية على احتياجاتكِ وأهدافكِ." },
        { key: "p3_num",    label: "Principle 3 — number/label",
          en: "03 — Principle", ar: "" },
        { key: "p3_title",  label: "Principle 3 — title",
          en: "Measured", ar: "نتائج مدروسة بعناية" },
        { key: "p3_body",   label: "Principle 3 — body",
          en: "Outcomes documented every quarter. No guesswork, no theatre — only what the skin shows when we compare it to where it began.",
          ar: "تبدأ رحلتكِ داخل عيادة تجميل للبشرة تهتم بفهم احتياجات بشرتكِ، واختيار الإجراءات المناسبة لكِ بناءً على تقييم متخصص، لتنعمي بتجربة عناية تناسب أهدافكِ التجميلية." }
      ]
    },
    {
      # July 2026 deck: retitled "About NeuSkin", third-person copy, AR added.
      kind: "home_founder", label: "About NeuSkin", position: 2,
      contents: [
        { key: "eyebrow", label: "Eyebrow",
          en: "About NeuSkin", ar: "عن نيوسكين" },
        { key: "body_1",  label: "Body paragraph 1",
          en: "NeuSkin was founded to move beyond the noise of mass-market beauty. We believe in a medical approach that values your time and trust above all else. Every woman deserves clarity, a bespoke plan, and results that honor her natural beauty, guided by patience and clinical expertise.",
          ar: "في نيوسكن، نؤمن أن الجمال لا يحتاج إلى تغيير ملامحكِ، بل إلى عناية تفهم احتياجاتكِ وتُبرز جمالكِ الطبيعي. لذلك، تأسست نيوسكن لتقدم مفهومًا مختلفًا في عالم التجميل، يجمع بين الخبرة الطبية، والتقنيات الحديثة، والاهتمام بالتفاصيل التي تصنع فارقًا حقيقيًا في تجربتكِ." },
        { key: "body_2",  label: "Body paragraph 2",
          en: "Our journey begins with a deep, intuitive understanding of your skin. Together, we prioritize what truly serves your long-term health, leaving behind the trends that don't.",
          ar: "نحن أكثر من مجرد عيادة تجميل؛ فنحن نؤمن بأن لكل امرأة احتياجاتها الخاصة، وأن البداية الصحيحة تأتي من فهم طبيعة بشرتها وأهدافها، ثم اختيار الحلول المناسبة لها بوضوح واهتمام. هدفنا أن تحصلي على تجربة عناية مدروسة، تشعرين فيها بالثقة والراحة، وتضع صحة بشرتكِ وجمالها الطبيعي في مقدمة أولوياتنا." },
        { key: "sign",    label: "Signature",
          en: "", ar: "" },
        { key: "link",    label: "Link text",
          en: "Read her philosophy →", ar: "" },
        # Client audit (Oct 2026): booking button under the About copy.
        { key: "cta",     label: "Button — book a consultation",
          hint: "Opens the online booking page. Leave blank to hide the button.",
          en: "Book your consultation now", ar: "احجزي استشارتكِ الآن" }
      ]
    },
    {
      kind: "home_protocols", label: "Six protocols — heading", position: 3,
      contents: [
        { key: "eyebrow",  label: "Eyebrow",
          en: "The Six Protocols", ar: "البروتوكولات الستة" },
        { key: "title",    label: "Heading",
          en: "Six protocols.", ar: "تعرفي على بروتوكولات عيادة تجميل نيوسكن" },
        { key: "title_em", label: "Heading (emphasis)",
          en: "One philosophy.", ar: "" },
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
    },
    {
      kind: "home_journal", label: "Latest from the Journal", position: 9,
      contents: [
        { key: "eyebrow",  label: "Eyebrow",                   en: "From the Journal", ar: "من المجلّة" },
        { key: "title",    label: "Heading (before emphasis)", en: "Latest notes,",    ar: "أحدث المقالات" },
        { key: "title_em", label: "Heading emphasis span",     en: "quietly kept.",    ar: "" },
        { key: "link",     label: "\"All notes\" link text",   en: "Read all notes →", ar: "كل المقالات ←" }
      ]
    }
])
