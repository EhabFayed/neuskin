# The Journal page hero becomes admin-editable like every other page —
# a journal/journal_hero section whose contents seed from the current copy.
class AddJournalHeroSection < ActiveRecord::Migration[8.0]
  CONTENTS = [
    { key: "eyebrow",  label: "Eyebrow",
      value_en: "The Journal", value_ar: "المجلّة" },
    { key: "title_1",  label: "Title — first line",
      value_en: "Notes, quietly", value_ar: "تدويناتٌ تُحفَظ" },
    { key: "title_em", label: "Title — italic line",
      value_en: "kept.", value_ar: "بهدوء." },
    { key: "lead",     label: "Lead paragraph",
      value_en: "A doctor's writing, the clinic from the inside, and the rituals in between — read at your own pace. Nothing trending, nothing rushed.",
      value_ar: "كتابات الطبيبة، والعيادة من الداخل، والطقوس بينهما — اقرئيها على مهلك. لا شيء رائج، ولا شيء مستعجل." }
  ].freeze

  def up
    section = Section.find_or_initialize_by(page: "journal", kind: "journal_hero")
    section.label = "Journal — hero"
    section.save!

    CONTENTS.each_with_index do |attrs, i|
      content = section.contents.find_or_initialize_by(key: attrs[:key])
      next if content.persisted? # don't clobber admin edits on re-run

      content.assign_attributes(attrs.merge(position: i + 1))
      content.save!
    end
    say "journal_hero section ready (#{section.contents.count} contents)"
  end

  def down
    Section.find_by(page: "journal", kind: "journal_hero")&.destroy
  end
end
