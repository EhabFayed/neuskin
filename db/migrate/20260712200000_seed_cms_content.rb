# Data migration: load the committed CMS content (db/content_seed) so a fresh
# deploy serves the real page copy — including all Arabic — instead of the
# English ERB fallbacks. Idempotent: upserts text, skips already-attached
# images (see ContentSeed.import). Safe on environments that already have
# content (e.g. local dev).
class SeedCmsContent < ActiveRecord::Migration[8.0]
  def up
    return unless File.exist?(Rails.root.join(ContentSeed::DEFAULT_DIR, "content.json"))

    stats = ContentSeed.import
    say "CMS content seeded: #{stats[:sections]} sections, #{stats[:contents]} contents"
  end

  def down
    # Content is data, not schema — nothing to reverse.
  end
end
