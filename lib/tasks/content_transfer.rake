# CMS content transfer — thin wrappers around ContentSeed (see lib/content_seed.rb).
# Export locally after editing content in the admin, commit db/content_seed,
# and the SeedCmsContent migration (or content:import) loads it on the server.
namespace :content do
  desc "Export sections, contents and attached images to db/content_seed"
  task export: :environment do
    stats = ContentSeed.export
    puts "Exported #{stats[:sections]} sections, #{stats[:contents]} contents, " \
         "#{stats[:files]} files to #{ContentSeed::DEFAULT_DIR}"
  end

  desc "Import sections/contents/images from db/content_seed (upsert, non-destructive)"
  task import: :environment do
    stats = ContentSeed.import
    puts "Imported: #{stats[:sections]} sections, #{stats[:contents]} contents now in DB"
  end

  # Called from db/seeds.rb — covers FRESH databases, where Rails loads
  # db/schema.rb and marks every migration applied WITHOUT running it, so the
  # SeedCmsContent data migration never fires. Existing databases get the same
  # import from that migration instead; both paths are idempotent.
  desc "Seed CMS content when db/content_seed exists (no-op otherwise)"
  task seed: :environment do
    if File.exist?(Rails.root.join(ContentSeed::DEFAULT_DIR, "content.json"))
      stats = ContentSeed.import
      puts "CMS content seeded: #{stats[:sections]} sections, #{stats[:contents]} contents"
    end
  end
end
