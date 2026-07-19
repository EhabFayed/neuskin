class CreateTreatments < ActiveRecord::Migration[8.0]
  def change
    create_table :treatments do |t|
      t.string  :slug, null: false
      t.integer :position, null: false, default: 0
      # Owning protocol for the "protocol that owns this" band (loose coupling,
      # mirrors the old PagesController::TREATMENT_OUTCOME_OWNERS map).
      t.string  :protocol_slug

      t.string :title_en
      t.string :title_ar
      t.string :headline_en
      t.string :headline_ar
      t.text   :look_en
      t.text   :look_ar
      t.text   :how_en
      t.text   :how_ar
      t.text   :view_en
      t.text   :view_ar

      t.timestamps
    end
    add_index :treatments, :slug, unique: true
  end
end
