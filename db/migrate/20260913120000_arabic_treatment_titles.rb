# Data migration — the five launch outcomes shipped with an empty title_ar, so
# the Arabic site (cards, header submenu) showed their English titles. Only
# rows still blank are filled; dashboard edits win.
class ArabicTreatmentTitles < ActiveRecord::Migration[8.0]
  TITLES_AR = {
    "skin"        => "بشرة متعبة وباهتة",
    "hair"        => "تساقط الشعر وخفّته",
    "body"        => "القوام والتحديد",
    "injectables" => "الخطوط والامتلاء",
    "devices"     => "الأجهزة المتقدّمة"
  }.freeze

  def up
    treatment = Class.new(ActiveRecord::Base) { self.table_name = "treatments" }
    TITLES_AR.each do |slug, ar|
      row = treatment.find_by(slug: slug) or next
      row.update!(title_ar: ar) if row.title_ar.blank?
    end
  end

  def down; end
end
