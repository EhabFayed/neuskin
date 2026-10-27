# FAQ questions become reusable across pages: each Faq keeps its /faq-page
# group (category) and gains
#   on_faq_page  — show in the FAQ page groups (default true)
#   placements   — pages that also show it, e.g. ["protocol:neuskin-method"]
# The protocol page's FAQ block now reads from these placements instead of the
# per-protocol JSONB list, so a question is written once in Admin → FAQ.
#
# Data: the old per-protocol JSONB questions are copied into Faq rows placed
# on their protocol (off the FAQ page), except for The NeuSkin Method, which
# gets the client's six questions instead. The protocol/template section gains
# the FAQ heading + subtitle lines. The JSONB column is left in place, unused.
class AddPlacementsToFaqs < ActiveRecord::Migration[8.0]
  METHOD_FAQS = [
    [ "هل الجلسة الأولى تشمل علاجات للبشرة؟", "Does the first session include skin treatments?",
      "لا، الجلسة الأولى مخصصة لتقييم البشرة والشعر والجسم، وفهم الاحتياجات ووضع خطة العناية المناسبة، دون إجراء علاجات خلالها.",
      "No. The first session is dedicated to assessing your skin, hair and body, understanding your needs and setting the right care plan. No treatments are performed during it." ],
    [ "كم تستغرق جلسة التقييم الأولى؟", "How long does the first assessment session take?",
      "تستغرق جلسة التقييم التشخيصي للعناية بالبشرة والشعر والجسم حوالي 60 دقيقة، بإشراف طبيبة متخصصة.",
      "The diagnostic assessment for skin, hair and body care takes about 60 minutes, under the supervision of a specialist doctor." ],
    [ "هل خطة نيو سكين مناسبة لجميع أنواع البشرة؟", "Is the NeuSkin plan suitable for all skin types?",
      "يتم تحديد مدى ملاءمة المنهج واحتياجات العناية وفقًا للتقييم الفردي لكل حالة، ولا تُعتمد خطة واحدة لجميع الأشخاص.",
      "How well the method fits, and the care it calls for, is decided by each person's individual assessment. No single plan is applied to everyone." ],
    [ "هل يجب الالتزام بالخطة لمدة 12 شهرًا كاملة؟", "Do I have to commit to the plan for a full 12 months?",
      "المنهج مبني على خطة تمتد لمدة 12 شهرًا، مع مراجعتها كل 3 أشهر لتقييم التقدم وتحديد الخطوات التالية.",
      "The method is built on a 12-month plan, reviewed every 3 months to assess progress and set the next steps." ],
    [ "متى يمكن ملاحظة نتائج خطة نيو سكين؟", "When can I expect to see results from the NeuSkin plan?",
      "يختلف ظهور النتائج حسب الحالة وطبيعة المشكلة والخطة الموصى بها. وتساعد المراجعات الدورية على تقييم التغيرات وتعديل خطوات العناية عند الحاجة.",
      "Results appear at different times depending on the case, the nature of the concern and the recommended plan. Regular reviews help assess the changes and adjust the care steps when needed." ],
    [ "كيف يمكنني حجز جلسة التقييم؟", "How do I book the assessment session?",
      "يمكنكِ بدء التواصل مع العيادة عبر واتساب أو نموذج الاستفسار لحجز جلسة التقييم ومعرفة الخطوات التالية.",
      "You can start by contacting the clinic on WhatsApp or through the inquiry form to book your assessment session and learn the next steps." ]
  ].freeze

  TEMPLATE_LINES = [
    { key: "faq", label: "FAQ — heading (h2)", value_en: "Frequently asked", value_ar: "الأسئلة الشائعة" },
    { key: "faq_subtitle", label: "FAQ — subtitle (h3)",
      value_en: "Everything you need to know before booking", value_ar: "كل ما تحتاجين معرفته قبل الحجز" }
  ].freeze

  def up
    add_column :faqs, :on_faq_page, :boolean, null: false, default: true
    add_column :faqs, :placements, :jsonb, null: false, default: []
    add_index  :faqs, :placements, using: :gin

    Faq.reset_column_information
    position = (Faq.unscoped.maximum(:position) || 0)

    # Old per-protocol JSONB questions → placed Faq rows (The NeuSkin Method
    # gets the client's list below instead).
    copied = 0
    Protocol.unscoped.where.not(slug: "neuskin-method").find_each do |protocol|
      Array(protocol.faqs).each do |f|
        next if f["q_en"].blank? && f["q_ar"].blank?
        next if Faq.unscoped.where(question_en: f["q_en"]).where("placements @> ?", [ "protocol:#{protocol.slug}" ].to_json).exists?

        Faq.create!(question_en: f["q_en"].presence || f["q_ar"], question_ar: f["q_ar"].presence || f["q_en"],
                    answer_en: f["a_en"].presence || f["a_ar"], answer_ar: f["a_ar"].presence || f["a_en"],
                    category: "how_care_works", on_faq_page: false,
                    placements: [ "protocol:#{protocol.slug}" ], position: (position += 1))
        copied += 1
      end
    end

    seeded = 0
    if Protocol.unscoped.exists?(slug: "neuskin-method")
      METHOD_FAQS.each do |q_ar, q_en, a_ar, a_en|
        next if Faq.unscoped.exists?(question_ar: q_ar)

        Faq.create!(question_en: q_en, question_ar: q_ar, answer_en: a_en, answer_ar: a_ar,
                    category: "how_care_works", on_faq_page: false,
                    placements: [ "protocol:neuskin-method" ], position: (position += 1))
        seeded += 1
      end
    end

    section = Section.find_or_initialize_by(page: "protocol", kind: "template")
    section.label ||= "Shared copy on every protocol page"
    section.save!
    base = section.contents.maximum(:position) || 0
    TEMPLATE_LINES.each_with_index do |attrs, i|
      content = section.contents.find_or_initialize_by(key: attrs[:key])
      next if content.persisted?

      content.assign_attributes(attrs.merge(position: base + i + 1))
      content.save!
    end

    say "faq placements ready: #{copied} protocol questions copied, #{seeded} seeded for The NeuSkin Method"
  end

  def down
    remove_index  :faqs, :placements
    remove_column :faqs, :placements
    remove_column :faqs, :on_faq_page
  end
end
