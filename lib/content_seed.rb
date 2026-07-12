# Transfers admin-entered CMS content (Sections + Contents + attached images)
# between environments via a directory committed to the repo (db/content_seed).
# The page copy — including every Arabic translation — lives in the DB, so
# deploying code alone leaves a fresh server on the English ERB fallbacks.
#
# Workflow: edit content in the local admin → `bin/rails content:export` →
# commit db/content_seed → deploy. A data migration (and the content:import
# task) call .import, which upserts by (page, kind) / content key: existing
# rows are updated, nothing is deleted, and already-attached images are left
# alone so server-side admin edits and re-runs are safe.
module ContentSeed
  DEFAULT_DIR = "db/content_seed"

  module_function

  def export(dir = Rails.root.join(DEFAULT_DIR))
    files_dir = dir.join("files")
    FileUtils.mkdir_p(files_dir)

    dump = Section.order(:page, :kind).map do |section|
      image_file = nil
      if section.image.attached?
        image_file = "#{section.page}__#{section.kind}__#{section.image.filename}"
        File.binwrite(files_dir.join(image_file), section.image.download)
      end
      gallery_files = section.gallery.attached? ? section.gallery.map.with_index do |img, i|
        name = "#{section.page}__#{section.kind}__gallery#{i}__#{img.filename}"
        File.binwrite(files_dir.join(name), img.download)
        name
      end : []

      {
        page: section.page, kind: section.kind, label: section.label,
        position: section.position, settings: section.settings, items: section.items,
        image: image_file, gallery: gallery_files,
        contents: section.contents.map do |c|
          c.slice("key", "label", "hint", "value_ar", "value_en", "content_type", "position")
        end
      }
    end

    File.write(dir.join("content.json"), JSON.pretty_generate(dump))
    { sections: dump.size, contents: dump.sum { |s| s[:contents].size },
      files: Dir[files_dir.join("*")].size }
  end

  def import(dir = Rails.root.join(DEFAULT_DIR))
    json = dir.join("content.json")
    raise "No content seed found at #{json}" unless File.exist?(json)
    files_dir = dir.join("files")

    JSON.parse(File.read(json)).each do |s|
      section = Section.find_or_initialize_by(page: s["page"], kind: s["kind"])
      section.assign_attributes(label: s["label"], position: s["position"],
                                settings: s["settings"], items: s["items"])
      section.save!

      s["contents"].each do |c|
        content = section.contents.find_or_initialize_by(key: c["key"])
        content.assign_attributes(c.slice("label", "hint", "value_ar", "value_en",
                                          "content_type", "position"))
        content.save!
      end

      # Attach images only when the slot is empty — re-runs and later
      # server-side uploads must not be clobbered or duplicated.
      if s["image"] && !section.image.attached? && File.exist?(files_dir.join(s["image"]))
        section.image.attach(io: File.open(files_dir.join(s["image"])),
                             filename: s["image"].split("__").last)
      end
      if s["gallery"].present? && !section.gallery.attached? &&
         s["gallery"].all? { |f| File.exist?(files_dir.join(f)) }
        s["gallery"].each do |f|
          section.gallery.attach(io: File.open(files_dir.join(f)), filename: f.split("__").last)
        end
      end
    end

    { sections: Section.count, contents: Content.count }
  end
end
