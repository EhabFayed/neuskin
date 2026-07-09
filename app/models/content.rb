class Content < ApplicationRecord
  include LocalizedValue
  extend Enumerize

  belongs_to :parentable, polymorphic: true, inverse_of: :contents

  enumerize :content_type, in: %i[text richtext plain], default: :text

  validates :key, presence: true

  # Locale-aware reader, mirrors Protocol's localized readers.
  def value
    localized(value_ar, value_en)
  end

  # Human-friendly field name for the admin. Falls back to a titleized key.
  def display_label
    label.presence || key.to_s.titleize
  end
end
