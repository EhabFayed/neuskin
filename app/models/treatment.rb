# A treatment outcome ("Tired, dull skin", "Thinning & shedding", …) — one
# card on /treatments and one sub-page at /treatments/<slug>. Fully managed
# in the dashboard (Admin::TreatmentsController), mirroring Protocol.
class Treatment < ApplicationRecord
  include DetailBlocks

  has_one_attached :image

  # Sub-page sections (client PDF, Nov 2026): hero, four question sections
  # (causes → how NeuSkin chooses → the options → after treatment) and a FAQ.
  detail_groups [
    { key: "hero", label: "Page hero (sub-page only)", fields: [
      [ "hero_title", :text, "Page title (h1)", "Shown on the sub-page only — the card on /treatments keeps its own headline. Blank = card headline." ],
      [ "hero_intro", :textarea, "Intro paragraph", "Blank = the card description." ],
      [ "hero_cta", :text, "Button label", "Opens the online booking page. Blank = “Book your consultation”." ] ] },
    { key: "s1", label: "Section 1 — the causes", fields: list_section_fields("s1", "Section 1") },
    { key: "s2", label: "Section 2 — how NeuSkin chooses the treatment", fields: list_section_fields("s2", "Section 2", numbered: true) },
    { key: "s3", label: "Section 3 — the treatment options", fields: list_section_fields("s3", "Section 3") },
    { key: "s4", label: "Section 4 — keeping the results", fields: list_section_fields("s4", "Section 4") },
    { key: "faq", label: "FAQ (up to six)", fields: faq_fields }
  ]

  validates :slug, presence: true, uniqueness: true
  validates :title_en, :headline_en, presence: true

  default_scope { order(:position) }

  # Public site only shows visible outcomes; the dashboard lists them all.
  # A hidden treatment keeps its copy, image and URL for when it returns.
  scope :visible, -> { where(hidden: false) }

  # Admin can leave the slug blank on create — derived from the English title.
  before_validation { self.slug = title_en.to_s.parameterize if slug.blank? }

  def to_param = slug

  # The protocol whose plan "owns" this outcome (optional).
  def protocol
    Protocol.find_by(slug: protocol_slug) if protocol_slug.present?
  end

  # Locale-aware readers: treatment.title returns title_ar or title_en for the
  # current I18n locale, falling back to English when Arabic is blank.
  %i[title headline look how view meta_title meta_description].each do |attr|
    define_method(attr) do
      ar = public_send("#{attr}_ar")
      en = public_send("#{attr}_en")
      I18n.locale == :ar && ar.present? ? ar : en
    end
  end
end
