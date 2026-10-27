# Hero rows under the protocol title (Duration · Format · For) become a
# per-protocol list editors can add to (Admin → Protocols → "Hero rows").
# Pre-filled on every protocol with exactly the three rows the page showed,
# so nothing changes until someone edits. A blank list falls back to the
# original three in the view.
class AddSpecsToProtocols < ActiveRecord::Migration[8.0]
  def up
    add_column :protocols, :specs, :jsonb, null: false, default: []
    Protocol.reset_column_information

    template = Section.find_by(page: "protocol", kind: "template")
    format_en = template&.contents&.find_by(key: "format_value")&.value_en.presence || "Doctor-led · personalised"
    format_ar = template&.contents&.find_by(key: "format_value")&.value_ar.presence || "بإشراف طبيبة · مخصّص لكِ"
    first = ->(text, fallback) { text.to_s.split(/[.\n]/).first.to_s.strip.presence || fallback }

    filled = 0
    Protocol.unscoped.where("specs = '[]'::jsonb").find_each do |p|
      p.update_columns(specs: [
        { "label_en" => "Duration", "label_ar" => "المدّة",
          "value_en" => p.duration_en.to_s, "value_ar" => p.duration_ar.to_s },
        { "label_en" => "Format", "label_ar" => "الصيغة",
          "value_en" => format_en, "value_ar" => format_ar },
        { "label_en" => "For", "label_ar" => "لمن",
          "value_en" => first.(p.who_for_en, "By assessment"), "value_ar" => first.(p.who_for_ar, "بحسب التقييم") }
      ])
      filled += 1
    end
    say "hero rows pre-filled on #{filled} protocols"
  end

  def down
    remove_column :protocols, :specs
  end
end
