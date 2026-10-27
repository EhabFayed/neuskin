# "Who it's for" signs — the numbered list beside the who-for paragraph on
# each protocol page. Was a fixed locale list shared by every protocol; now
# per protocol, one sign per line, edited in Admin → Protocols. Blank falls
# back to the original locale lines so existing pages don't change.
class AddSignsToProtocols < ActiveRecord::Migration[8.0]
  def change
    add_column :protocols, :signs_en, :text
    add_column :protocols, :signs_ar, :text
  end
end
