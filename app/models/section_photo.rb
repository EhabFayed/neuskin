# One photo of a Section album (The Clinic → "The Space"), with its own
# bilingual caption. Albums are edited one photo at a time in the dashboard
# (add with caption, edit captions, delete), and the public page shows the
# caption behind a per-photo toggle button.
class SectionPhoto < ApplicationRecord
  include LocalizedValue

  belongs_to :section, inverse_of: :photos
  has_one_attached :image

  # Caption for the active locale; an Arabic page falls back to the English
  # caption when the Arabic one is blank (same convention as the page copy).
  def caption
    localized(caption_ar, caption_en) || caption_en.presence.to_s
  end
end
