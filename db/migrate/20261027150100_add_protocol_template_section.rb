# The copy shared by EVERY protocol page (the lines that are not about one
# protocol) becomes admin-editable like every other page: a protocol/template
# section under Pages → "Protocol page (shared copy)", seeded from the current
# locale strings. The view keeps those strings as fallbacks.
class AddProtocolTemplateSection < ActiveRecord::Migration[8.0]
  CONTENTS = [
    { key: "format_value", label: "Hero — “Format” value",
      value_en: "Doctor-led · personalised", value_ar: "بإشراف طبيبة · مخصّص لكِ" },
    { key: "not_for_all", label: "Who it's for — closing line",
      value_en: "This protocol is not for everyone — and that is intentional.",
      value_ar: "هذا البروتوكول ليس للجميع — وهذا مقصود." },
    { key: "scope_note", label: "What's inside — note under the timeline",
      value_en: "Final protocol scope is confirmed during your NeuSkin Method™ assessment. All treatments are personalised.",
      value_ar: "يُحدَّد النطاق النهائي للبروتوكول خلال تقييم منهج نيوسكن™. كل العلاجات مخصّصة لكِ." },
    { key: "honesty", label: "What's not included — heading",
      value_en: "Honesty, set early.", value_ar: "الصدق، منذ البداية." },
    { key: "journey_1_title", label: "Journey step 1 — title", value_en: "Inquire", value_ar: "استفسري" },
    { key: "journey_1_body",  label: "Journey step 1 — line",
      value_en: "A private message, reviewed personally.", value_ar: "رسالة خاصة تُراجَع شخصيًا." },
    { key: "journey_2_title", label: "Journey step 2 — title", value_en: "Consult", value_ar: "استشيري" },
    { key: "journey_2_body",  label: "Journey step 2 — line",
      value_en: "A doctor-led diagnostic assessment.", value_ar: "تقييم تشخيصي بإشراف طبيبة." },
    { key: "journey_3_title", label: "Journey step 3 — title", value_en: "Plan", value_ar: "خطّطي" },
    { key: "journey_3_body",  label: "Journey step 3 — line",
      value_en: "A written, sequenced roadmap.", value_ar: "خارطة طريق مكتوبة ومتسلسلة." },
    { key: "journey_4_title", label: "Journey step 4 — title", value_en: "Treat", value_ar: "عالجي" },
    { key: "journey_4_body",  label: "Journey step 4 — line",
      value_en: "Sessions, reviewed each quarter.", value_ar: "جلسات تُراجَع كل ربع سنة." }
  ].freeze

  def up
    section = Section.find_or_initialize_by(page: "protocol", kind: "template")
    section.label = "Shared copy on every protocol page"
    section.save!

    CONTENTS.each_with_index do |attrs, i|
      content = section.contents.find_or_initialize_by(key: attrs[:key])
      next if content.persisted? # don't clobber admin edits on re-run

      content.assign_attributes(attrs.merge(position: i + 1))
      content.save!
    end
    say "protocol/template section ready (#{section.contents.count} contents)"
  end

  def down
    Section.find_by(page: "protocol", kind: "template")&.destroy
  end
end
