# The Medical Team as records — dynamic like top_brand's leadership team
# section (repeated bilingual entries, each with a photo), done neuskin-style
# as a first-class model with paired _ar/_en columns and ActiveStorage.
class CreateTeamMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :team_members do |t|
      t.string  :name_ar
      t.string  :name_en
      t.string  :role_ar
      t.string  :role_en
      t.string  :cred_ar
      t.string  :cred_en
      t.string  :focus_ar
      t.string  :focus_en
      t.text    :bio_ar
      t.text    :bio_en
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :team_members, :position
  end
end
