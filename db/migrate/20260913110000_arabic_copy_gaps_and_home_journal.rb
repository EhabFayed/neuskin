# Data migration — client audit, Sept 2026 (item 10: "the Arabic version has
# a lot of English"). Fills the CMS values whose Arabic side was left blank
# (so the page fell back to English), gives the six protocols Arabic display
# names, and registers the new home_journal section so its heading is
# editable in the dashboard. Idempotent: only blank/English values are touched.
class ArabicCopyGapsAndHomeJournal < ActiveRecord::Migration[8.0]
  ARABIC_CONTENT = {
    [ "treatments", "treatments_hero", "eyebrow" ]           => "العلاجات · حسب النتيجة",
    [ "treatments", "treatments_footer", "protocols_link" ]  => "اطّلعي على البروتوكولات الستة ←",
    [ "treatments", "treatments_footer", "card_cta" ]        => "اكتشفي المنهج ←",
    [ "treatments", "treatments_cta", "kicker" ]             => "لستِ متأكدة من أين تبدئين؟",
    [ "treatments", "treatments_cta", "title" ]              => "ابدئي مع",
    [ "treatments", "treatments_cta", "title_em" ]           => "منهج نيوسكن™",
    [ "treatments", "treatments_cta", "button" ]             => "اطلبي التقييم",
    [ "technologies", "tech_intro", "eyebrow" ]              => "المعيار",
    [ "home", "home_principles", "eyebrow" ]                 => "وعدنا",
    [ "home", "home_principles", "p1_num" ]                  => "٠١ — المبدأ",
    [ "home", "home_principles", "p2_num" ]                  => "٠٢ — المبدأ",
    [ "home", "home_principles", "p3_num" ]                  => "٠٣ — المبدأ",
    [ "home", "home_founder", "link" ]                       => "اقرئي فلسفتها ←",
    [ "private_care", "private_tiers", "tier_3_badge" ]      => "III"
  }.freeze

  # Arabic display names for the launch protocols. The English name stays in
  # name_en (and on the EN site); only rows still carrying the English name in
  # name_ar are updated, so dashboard edits are never overwritten.
  PROTOCOL_NAMES_AR = {
    "neuskin-method"    => "منهج نيوسكن",
    "90-day-glow-reset" => "إشراقة ٩٠ يومًا",
    "brides-180"        => "العروس ١٨٠",
    "reset-crown"       => "استعادة التاج",
    "8-week-sculpt"     => "نحت ٨ أسابيع",
    "skin-insider"      => "عضوية سكين إنسايدر"
  }.freeze

  HOME_JOURNAL = [
    { key: "eyebrow",  label: "Eyebrow",                    en: "From the Journal",  ar: "من المجلّة" },
    { key: "title",    label: "Heading (before emphasis)",  en: "Latest notes,",     ar: "أحدث المقالات،" },
    { key: "title_em", label: "Heading emphasis span",      en: "quietly kept.",     ar: "بهدوء." },
    { key: "link",     label: "\"All notes\" link text",    en: "Read all notes →",  ar: "كل المقالات ←" }
  ].freeze

  def up
    section = Class.new(ActiveRecord::Base) { self.table_name = "sections" }
    content = Class.new(ActiveRecord::Base) { self.table_name = "contents" }
    protocol = Class.new(ActiveRecord::Base) { self.table_name = "protocols" }

    ARABIC_CONTENT.each do |(page, kind, key), ar|
      sec = section.find_by(page: page, kind: kind) or next
      row = content.find_by(parentable_type: "Section", parentable_id: sec.id, key: key) or next
      next if row.value_ar.present? && row.value_ar !~ /\A[\x00-\x7F]*\z/ # already Arabic
      row.update!(value_ar: ar)
    end

    PROTOCOL_NAMES_AR.each do |slug, ar|
      p = protocol.find_by(slug: slug) or next
      next if p.name_ar.present? && p.name_ar != p.name_en
      p.update!(name_ar: ar)
    end

    home = section.find_or_create_by!(page: "home", kind: "home_journal") do |s|
      s.label = "Latest from the Journal"
      s.position = 9
      s.settings = {}
      s.items = []
    end
    HOME_JOURNAL.each_with_index do |c, i|
      row = content.find_or_initialize_by(parentable_type: "Section", parentable_id: home.id, key: c[:key])
      row.label        = c[:label]
      row.value_en     = c[:en] if row.value_en.blank?
      row.value_ar     = c[:ar] if row.value_ar.blank?
      row.content_type ||= "text"
      row.position     = i
      row.save!
    end
  end

  def down
    # Data only — nothing to reverse.
  end
end
