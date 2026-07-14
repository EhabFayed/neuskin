# Data migration: seed the three launch stories on existing databases, then
# retire the old fixed-key stories/story_items section (page reads Story now).
class SeedStories < ActiveRecord::Migration[8.0]
  def up
    seed_file = Rails.root.join("db/seeds/stories.rb")
    load seed_file if File.exist?(seed_file)
    say "Stories in DB: #{Story.count}"

    Section.find_by(page: "stories", kind: "story_items")&.destroy
  end

  def down
    # Data, not schema — nothing to reverse.
  end
end
