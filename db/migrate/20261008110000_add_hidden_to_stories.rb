# Patient stories can be hidden from /stories without deleting them — same
# switch as treatments (dashboard → Stories → Hidden from site).
#
# Data step: every existing story is hidden for now (client request, Oct
# 2026) — the page keeps its hero and reads as "coming soon" until stories
# are unticked in the dashboard. New stories default to visible.
class AddHiddenToStories < ActiveRecord::Migration[8.0]
  def up
    add_column :stories, :hidden, :boolean, default: false, null: false

    story = Class.new(ActiveRecord::Base) { self.table_name = "stories" }
    story.update_all(hidden: true)
  end

  def down
    remove_column :stories, :hidden
  end
end
