namespace :content do
  desc "Seed editable Sections/Contents from current copy (idempotent, all pages)"
  task seed: :environment do
    # Each db/seed_content/*.rb registers its page via SeedContent.register.
    require Rails.root.join("db/seed_content/_registry")
    SeedContent.reset!
    Dir[Rails.root.join("db/seed_content/*.rb")].sort.each { |f| load f }

    total_sections = 0
    SeedContent.pages.each do |page, sections|
      sections.each_with_index do |sec, si|
        section = Section.find_or_initialize_by(page: page, kind: sec[:kind])
        section.label    = sec[:label]
        section.position = sec[:position] || si
        section.save!
        total_sections += 1

        Array(sec[:contents]).each_with_index do |c, i|
          content = Content.find_or_initialize_by(parentable: section, key: c[:key])
          content.label        = c[:label]
          content.value_en     = c[:en]
          content.value_ar     = c[:ar]
          content.content_type = c[:content_type] || "text"
          content.position     = i
          content.save!
        end

        # Optional repeating-group items (JSONB) for a section.
        section.update!(items: sec[:items]) if sec.key?(:items)
      end
    end

    puts "Seeded #{total_sections} sections across #{SeedContent.pages.size} pages."
  end
end
