# A treatment outcome ("Tired, dull skin", "Thinning & shedding", …) — one
# card on /treatments and one sub-page at /treatments/<slug>. Fully managed
# in the dashboard (Admin::TreatmentsController), mirroring Protocol.
class Treatment < ApplicationRecord
  has_one_attached :image

  validates :slug, presence: true, uniqueness: true
  validates :title_en, :headline_en, presence: true

  default_scope { order(:position) }

  # Admin can leave the slug blank on create — derived from the English title.
  before_validation { self.slug = title_en.to_s.parameterize if slug.blank? }

  def to_param = slug

  # The protocol whose plan "owns" this outcome (optional).
  def protocol
    Protocol.find_by(slug: protocol_slug) if protocol_slug.present?
  end

  # Locale-aware readers: treatment.title returns title_ar or title_en for the
  # current I18n locale, falling back to English when Arabic is blank.
  %i[title headline look how view].each do |attr|
    define_method(attr) do
      ar = public_send("#{attr}_ar")
      en = public_send("#{attr}_en")
      I18n.locale == :ar && ar.present? ? ar : en
    end
  end
end
