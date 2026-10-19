# The Clinic → "The Space" album: one record per photo, each with its own
# bilingual caption, instead of a has_many_attached gallery plus five fixed
# shot_N_caption text fields (so photos 6+ were caption-less).
#
# Data move (clinic_space only — other gallery sections keep `gallery`):
#   * each gallery attachment becomes a SectionPhoto (same order) and the
#     attachment row is re-pointed at it, so blobs are untouched;
#   * shot_N_caption contents are copied onto photo N, then removed.
class CreateSectionPhotos < ActiveRecord::Migration[8.0]
  ALBUM = { page: "the_clinic", kind: "clinic_space" }.freeze

  class MigSection < ActiveRecord::Base
    self.table_name = "sections"
  end

  class MigContent < ActiveRecord::Base
    self.table_name = "contents"
  end

  class MigAttachment < ActiveRecord::Base
    self.table_name = "active_storage_attachments"
  end

  class MigPhoto < ActiveRecord::Base
    self.table_name = "section_photos"
  end

  def up
    create_table :section_photos do |t|
      t.references :section, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.text :caption_en
      t.text :caption_ar
      t.timestamps
    end
    add_index :section_photos, [ :section_id, :position ]

    section = MigSection.find_by(ALBUM) or return
    captions = MigContent.where(parentable_type: "Section", parentable_id: section.id)
                         .where("key LIKE 'shot_%_caption'")
    by_index = captions.index_by { |c| c.key[/\d+/].to_i }

    attachments = MigAttachment.where(record_type: "Section", record_id: section.id, name: "gallery").order(:id)
    attachments.each_with_index do |att, i|
      cap = by_index[i + 1]
      photo = MigPhoto.create!(section_id: section.id, position: i,
                               caption_en: cap&.value_en, caption_ar: cap&.value_ar)
      att.update!(record_type: "SectionPhoto", record_id: photo.id, name: "image")
    end
    captions.delete_all
  end

  def down
    MigPhoto.order(:position, :id).each do |photo|
      MigAttachment.where(record_type: "SectionPhoto", record_id: photo.id, name: "image")
                   .update_all(record_type: "Section", record_id: photo.section_id, name: "gallery")
    end
    drop_table :section_photos
  end
end
