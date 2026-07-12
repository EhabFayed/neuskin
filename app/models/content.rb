class Content < ApplicationRecord
  include LocalizedValue
  extend Enumerize

  belongs_to :parentable, polymorphic: true, inverse_of: :contents

  # Optional inline image for journal paragraphs (top_brand blog_con_photos,
  # folded into Content). Section contents simply never attach one.
  has_one_attached :photo

  enumerize :content_type, in: %i[text richtext plain], default: :text

  validates :key, presence: true

  # Admin "remove image" checkbox — read by Admin::BlogsController, which
  # purges after save (a virtual attr never marks the record dirty, so an
  # after_save hook here would not fire).
  attr_accessor :remove_photo

  # Locale-aware reader, mirrors Protocol's localized readers.
  def value
    localized(value_ar, value_en)
  end

  # Locale-aware alt text for the attached photo.
  def alt
    localized(alt_ar, alt_en)
  end

  # Human-friendly field name for the admin. Falls back to a titleized key.
  def display_label
    label.presence || key.to_s.titleize
  end

end
