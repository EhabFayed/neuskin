# Data migration: seed the six launch Journal posts on databases that already
# exist (deploys run pending migrations, not db:seed). Fresh databases get the
# same posts from db/seeds.rb instead; the seed file is idempotent by slug, so
# both paths are safe.
class SeedJournalPosts < ActiveRecord::Migration[8.0]
  def up
    seed_file = Rails.root.join("db/seeds/blogs.rb")
    return unless File.exist?(seed_file)

    load seed_file
    say "Journal posts in DB: #{Blog.count}"
  end

  def down
    # Posts are data, not schema — nothing to reverse.
  end
end
