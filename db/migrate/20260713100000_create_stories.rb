# Patient stories as records — dynamic counterpart of the old fixed-key
# stories/story_items section (same pattern as TeamMember/Faq).
class CreateStories < ActiveRecord::Migration[8.0]
  def change
    create_table :stories do |t|
      t.text    :intro_ar
      t.text    :intro_en
      t.text    :quote_ar
      t.text    :quote_en
      t.string  :protocol_line_ar
      t.string  :protocol_line_en
      t.text    :close_ar
      t.text    :close_en
      t.string  :byline_ar
      t.string  :byline_en
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :stories, :position
  end
end
