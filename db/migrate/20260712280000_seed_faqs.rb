# Data migration: seed the nine launch FAQs on existing databases (deploys run
# pending migrations, not db:seed; fresh DBs get them from db/seeds.rb), then
# retire the old fixed-key faq/faq_items section — the page reads Faq records.
class SeedFaqs < ActiveRecord::Migration[8.0]
  def up
    seed_file = Rails.root.join("db/seeds/faqs.rb")
    load seed_file if File.exist?(seed_file)
    say "FAQs in DB: #{Faq.count}"

    Section.find_by(page: "faq", kind: "faq_items")&.destroy
  end

  def down
    # Data, not schema — nothing to reverse.
  end
end
