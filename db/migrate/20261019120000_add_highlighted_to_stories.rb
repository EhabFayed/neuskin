# Client audit (Oct 2026): the home-page reviews band shows only stories that
# are both visible and ticked "Highlight on home" in Admin → Stories.
class AddHighlightedToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :highlighted, :boolean, default: false, null: false
    add_index :stories, :highlighted
  end
end
