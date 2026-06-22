class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.string :name,            null: false
      t.string :mobile,          null: false   # KSA, stored as +9665XXXXXXXX
      t.string :email
      t.string :preferred_locale                # ar / en
      t.string :persona                         # what brings you here (enumerized)
      t.string :preferred_time                  # free text, e.g. "Evenings"
      t.string :source_codeword                 # protocol/channel the inquiry came from

      t.timestamps
    end

    add_index :inquiries, :created_at
  end
end
