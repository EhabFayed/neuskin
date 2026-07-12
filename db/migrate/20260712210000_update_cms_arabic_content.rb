# Data migration: re-import db/content_seed after the full Arabic translation
# pass (2026-07-12) — all 388 content rows now carry value_ar. The original
# SeedCmsContent migration is already "up" on deployed databases, so a second
# migration is needed for db:prepare to apply the updated seed on deploy.
# Idempotent: text upserts, already-attached images are skipped.
class UpdateCmsArabicContent < ActiveRecord::Migration[8.0]
  def up
    return unless File.exist?(Rails.root.join(ContentSeed::DEFAULT_DIR, "content.json"))

    stats = ContentSeed.import
    say "CMS content refreshed: #{stats[:sections]} sections, #{stats[:contents]} contents"
  end

  def down
    # Content is data, not schema — nothing to reverse.
  end
end
