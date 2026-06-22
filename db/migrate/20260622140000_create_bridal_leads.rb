class CreateBridalLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :bridal_leads do |t|
      t.string :email,        null: false
      t.date   :wedding_date                 # optional — for the nurture sequence
      t.string :preferred_locale

      t.timestamps
    end

    add_index :bridal_leads, :created_at
  end
end
