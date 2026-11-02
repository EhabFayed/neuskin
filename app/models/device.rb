# A device card on /technologies (EMTONE, EMFACE, …) — front face carries the
# patient-facing story over a product shot, the back face the technical specs
# over an in-clinic photo. Fully managed in the dashboard
# (Admin::DevicesController), mirroring Treatment. Names are brand names and
# are never translated.
class Device < ApplicationRecord
  include DetailBlocks

  has_one_attached :front_image
  has_one_attached :back_image

  # Device page sections (client PDF, Nov 2026): hero, what it is, how it
  # works, benefits, session steps, who it suits, why NeuSkin, FAQ.
  detail_groups [
    { key: "hero", label: "Page hero", fields: [
      [ "hero_eyebrow", :text, "Small line above the title", "e.g. “EMTONE technology”. Blank = “Our technologies · tagline”." ],
      [ "hero_title", :text, "Page title (h1)", "Blank = the device name." ],
      [ "hero_intro", :textarea, "Intro paragraph", "Blank = the card copy." ],
      [ "hero_cta", :text, "Button label", "Opens the online booking page. Blank = “Book your consultation”." ] ] },
    { key: "what", label: "What it is (next to the product photo)", fields: [
      [ "what_title", :text, "Heading (h2)", nil ],
      [ "what_body", :textarea, "Paragraph", nil ] ] },
    { key: "how", label: "How it works", fields: list_section_fields("how", "How it works") },
    { key: "benefits", label: "Benefits", fields: list_section_fields("benefits", "Benefits", subtitle: true) },
    { key: "steps", label: "Session steps", fields: list_section_fields("steps", "Session steps", numbered: true) },
    { key: "who", label: "Who it suits", fields: list_section_fields("who", "Who it suits") },
    { key: "why", label: "Why NeuSkin", fields: list_section_fields("why", "Why NeuSkin") },
    { key: "faq", label: "FAQ (up to six)", fields: faq_fields }
  ]

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-]+\z/, message: "lowercase letters, digits and dashes only" }

  default_scope { order(:position) }

  # Every device has its own page at /technologies/<slug>. The slug is derived
  # from the brand name unless the dashboard sets one explicitly.
  before_validation { self.slug = name.to_s.parameterize if slug.blank? }

  def to_param = slug

  # Locale-aware readers: device.tagline returns tagline_ar or tagline_en for
  # the current I18n locale, falling back to English when Arabic is blank.
  %i[tagline body specs meta_title meta_description].each do |attr|
    define_method(attr) do
      ar = public_send("#{attr}_ar")
      en = public_send("#{attr}_en")
      I18n.locale == :ar && ar.present? ? ar : en
    end
  end
end
