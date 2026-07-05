namespace :content do
  desc "Seed editable Sections/Contents from current copy (idempotent)"
  task seed: :environment do
    require Rails.root.join("db/seed_content/home")

    SeedContent::HOME.each do |sec|
      section = Section.find_or_initialize_by(page: "home", kind: sec[:kind])
      section.label    = sec[:label]
      section.position = sec[:position]
      section.save!

      sec[:contents].each_with_index do |c, i|
        content = Content.find_or_initialize_by(parentable: section, key: c[:key])
        content.label        = c[:label]
        content.value_en     = c[:en]
        content.value_ar     = c[:ar]
        content.content_type = c[:content_type] || "text"
        content.position     = i
        content.save!
      end
    end

    puts "Seeded #{Section.where(page: 'home').count} home sections."
  end
end
