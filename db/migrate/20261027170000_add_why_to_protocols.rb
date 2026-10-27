# "Why choose …" — a new block on the protocol page after "What's inside":
# an h2 title and a numbered list of reasons, per protocol, edited in
# Admin → Protocols (title pair + rows). Seeded for The NeuSkin Method with
# the client's copy; other protocols stay blank and hide the block.
class AddWhyToProtocols < ActiveRecord::Migration[8.0]
  POINTS = [
    [ "تقييم متخصص: لفهم حالة بشرتك واحتياجاتها بدقة.",
      "Expert assessment: a precise understanding of your skin's condition and needs." ],
    [ "خطة مخصصة: برنامج عناية مصمم وفقًا لحالتك وأهدافك.",
      "A personalised plan: a care programme designed around your condition and goals." ],
    [ "نهج متكامل: الاهتمام باحتياجات البشرة والشعر والجسم ضمن خطة واضحة.",
      "An integrated approach: skin, hair and body needs, addressed within one clear plan." ],
    [ "متابعة دورية: مراجعة الخطة كل 3 أشهر وتعديلها حسب تطور الحالة.",
      "Regular follow-up: the plan is reviewed every 3 months and adjusted as your condition evolves." ],
    [ "رؤية طويلة المدى: رحلة عناية منظمة تمتد على مدار 12 شهرًا، بدلًا من الاعتماد على التجربة العشوائية للمنتجات.",
      "A long-term view: a structured care journey over 12 months, instead of trial and error with products." ],
    [ "تحسين مظهر البشرة وملمسها، ودعم نضارتها وتوحيد لونها حسب احتياجاتها.",
      "Improving the look and feel of the skin, supporting its radiance and evening its tone, according to its needs." ],
    [ "تحسين مظهر الشعر والعناية بفروة الرأس، مع تحديد الخطوات المناسبة حسب حالة الشعر.",
      "Improving the look of the hair and caring for the scalp, with the right steps for your hair's condition." ],
    [ "وضع خطة عناية تراعى احتياجات الجسم وأهدافك، وفقًا للتقييم الأولي.",
      "A care plan that considers your body's needs and your goals, based on the initial assessment." ]
  ].freeze

  def up
    add_column :protocols, :why_title_en, :string
    add_column :protocols, :why_title_ar, :string
    add_column :protocols, :why_points, :jsonb, null: false, default: []

    Protocol.reset_column_information
    method = Protocol.unscoped.find_by(slug: "neuskin-method")
    return say("neuskin-method not found — nothing seeded") if method.nil?

    method.update_columns(
      why_title_en: "Why choose the NeuSkin Method?",
      why_title_ar: "لماذا تختارين منهج نيو سكين؟",
      why_points: POINTS.map { |ar, en| { "text_en" => en, "text_ar" => ar } }
    )
    say "why block seeded on neuskin-method (#{POINTS.size} points)"
  end

  def down
    remove_column :protocols, :why_points
    remove_column :protocols, :why_title_ar
    remove_column :protocols, :why_title_en
  end
end
