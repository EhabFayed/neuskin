# Promo codes for the Digital Gift Card page (/promo). Each row is one gift:
# a name, a percentage, a code and the copy shown above it on the card, plus
# a use limit the dashboard controls.
class CreatePromos < ActiveRecord::Migration[8.0]
  def change
    create_table :promos do |t|
      t.string  :label_en, null: false            # gift / treatment name, e.g. "Skin Boosters"
      t.string  :label_ar
      t.integer :percent, null: false             # 1..100, shown as "30% off"
      t.string  :code, null: false                # e.g. GLOW30 (stored upcased)
      t.string  :title_en, null: false            # line above the code
      t.string  :title_ar
      t.text    :description_en                   # optional second line
      t.text    :description_ar
      t.integer :max_uses                         # nil = unlimited
      t.integer :uses_count, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :promos, :code, unique: true
    add_index :promos, [ :active, :position ]
  end
end
