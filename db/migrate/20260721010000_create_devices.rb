class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices do |t|
      t.string  :name, null: false          # brand name — never translated
      t.integer :position, default: 0, null: false
      t.string  :tagline_en
      t.string  :tagline_ar
      t.text    :body_en                    # card front — patient-facing story
      t.text    :body_ar
      t.text    :specs_en                   # card back — technical specs
      t.text    :specs_ar
      t.timestamps
    end
  end
end
