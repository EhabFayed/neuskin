# A device card on /technologies (EMTONE, EMFACE, …) — front face carries the
# patient-facing story over a product shot, the back face the technical specs
# over an in-clinic photo. Fully managed in the dashboard
# (Admin::DevicesController), mirroring Treatment. Names are brand names and
# are never translated.
class Device < ApplicationRecord
  has_one_attached :front_image
  has_one_attached :back_image

  validates :name, presence: true

  default_scope { order(:position) }

  # Locale-aware readers: device.tagline returns tagline_ar or tagline_en for
  # the current I18n locale, falling back to English when Arabic is blank.
  %i[tagline body specs].each do |attr|
    define_method(attr) do
      ar = public_send("#{attr}_ar")
      en = public_send("#{attr}_en")
      I18n.locale == :ar && ar.present? ? ar : en
    end
  end
end
