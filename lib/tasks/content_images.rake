namespace :content do
  desc "Attach current static images to their Sections (idempotent)"
  task seed_images: :environment do
    require Rails.root.join("db/seed_content/_images")
    include ApplicationHelper # for NS_IMAGES

    attach = lambda do |section, key|
      path = Rails.root.join("app/assets/images", ApplicationHelper::NS_IMAGES.fetch(key))
      { io: File.open(path), filename: File.basename(path),
        content_type: Marcel::MimeType.for(path) }
    end

    single = 0
    SeedImages::SINGLE.each do |(page, kind), key|
      s = Section.find_by(page: page, kind: kind) or next
      next if s.image.attached? # don't clobber editor uploads
      s.image.attach(attach.call(s, key)); single += 1
    end

    galleries = 0
    SeedImages::GALLERY.each do |(page, kind), keys|
      s = Section.find_by(page: page, kind: kind) or next
      next if s.gallery.attached?
      keys.each { |k| s.gallery.attach(attach.call(s, k)) }
      galleries += 1
    end

    puts "Attached #{single} section images + #{galleries} galleries."
  end
end
