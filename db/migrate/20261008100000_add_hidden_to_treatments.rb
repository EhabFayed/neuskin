# Treatments can be hidden from the public site without deleting them: a
# hidden outcome drops out of the header submenu, the /treatments cards, the
# sitemap and its own /treatments/<slug> page (which 301s home like any
# unknown URL). Toggled from the dashboard (Treatments → Hidden from site).
#
# Data step: the "Thinning & shedding" (hair) outcome is hidden for now
# (client request, Oct 2026) — restore it by unticking the box in the dashboard.
class AddHiddenToTreatments < ActiveRecord::Migration[8.0]
  def up
    add_column :treatments, :hidden, :boolean, default: false, null: false

    treatment = Class.new(ActiveRecord::Base) { self.table_name = "treatments" }
    treatment.where(slug: "hair").update_all(hidden: true)
  end

  def down
    remove_column :treatments, :hidden
  end
end
