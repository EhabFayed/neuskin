class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.references :parentable, polymorphic: true, null: false
      t.string  :key,          null: false
      t.string  :label
      t.string  :hint
      t.text    :value_ar
      t.text    :value_en
      t.string  :content_type, null: false, default: "text"
      t.integer :position,     null: false, default: 0
      t.timestamps
    end
    add_index :contents, [:parentable_type, :parentable_id, :key],
              unique: true, name: "index_contents_on_parent_and_key"
  end
end
