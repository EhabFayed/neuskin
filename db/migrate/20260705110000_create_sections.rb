class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string  :page,     null: false
      t.string  :kind,     null: false
      t.string  :label
      t.integer :position, null: false, default: 0
      t.jsonb   :settings, null: false, default: {}
      t.jsonb   :items,    null: false, default: []
      t.timestamps
    end
    add_index :sections, [:page, :kind], unique: true
    add_index :sections, :page
  end
end
