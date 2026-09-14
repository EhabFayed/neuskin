# A Journal post. Data design ported from the top_brand blog (paired _ar/_en
# columns, dual slug_en/slug_ar, is_published, category, cover image) —
# paragraph blocks live in the polymorphic Content model, like Section.
class Blog < ApplicationRecord
  extend Enumerize

  # Journal categories — the editorial strands from the design's filter row.
  enumerize :category, in: %i[clinic_notes inside_clinic ritual patient_notes],
                       default: :inside_clinic, scope: true

  has_many :contents, -> { order(:position) },
           as: :parentable, dependent: :destroy, inverse_of: :parentable
  accepts_nested_attributes_for :contents, allow_destroy: true, reject_if: :all_blank

  # Cover image. `image` is the default (and the English article's cover);
  # `image_ar` is an OPTIONAL Arabic-only cover — when a post's artwork carries
  # text, each language needs its own file. Arabic falls back to `image`.
  has_one_attached :image
  has_one_attached :image_ar

  validates :slug_en, presence: true, uniqueness: true,
                      format: { with: /\A[a-z0-9-]+\z/, message: "lowercase letters, digits and dashes only" }
  validates :slug_ar, uniqueness: true, allow_blank: true
  validates :title_en, :title_ar, presence: true

  scope :published, -> { where(is_published: true) }
  scope :newest_first, -> { order(created_at: :desc) }

  before_validation :derive_slugs

  # Localized pretty URL — Arabic pages link the Arabic slug when present.
  def to_param
    I18n.locale == :ar && slug_ar.present? ? slug_ar : slug_en
  end

  # Same page must resolve from either slug (the locale switcher keeps the
  # current path, so /journal/<slug_ar> can arrive with locale :en and back).
  def self.find_by_any_slug!(slug)
    where(slug_en: slug).or(where(slug_ar: slug)).first ||
      raise(ActiveRecord::RecordNotFound, "no blog with slug #{slug.inspect}")
  end

  # Locale-aware readers, mirroring Protocol (title -> title_ar / title_en).
  %i[title excerpt meta_title meta_description alt].each do |attr|
    define_method(attr) do
      public_send("#{attr}_#{localized_suffix}")
    end
  end

  # The cover for the active locale: the Arabic file on Arabic pages when one
  # is attached, the default cover otherwise. Never nil — callers check
  # `.attached?` exactly as before.
  def localized_image
    return image_ar if I18n.locale == :ar && image_ar.attached?

    image
  end

  # Localized pick for a JSONB hash with _ar/_en keys — mirrors Protocol#loc,
  # used by the per-article FAQ rows: blog.loc(faq, "q") -> faq["q_ar"].
  def loc(hash, key)
    return if hash.blank?
    hash["#{key}_#{localized_suffix}"]
  end

  # FAQ rows that have a question in the active locale (skip half-filled rows).
  def localized_faqs
    Array(faqs).select { |f| f.is_a?(Hash) && loc(f, "q").present? }
  end

  # Body paragraphs for the active locale (blank ones dropped).
  def paragraphs
    contents.filter_map { |c| c.value.presence }
  end

  # "6 min read" input — ~200 words/minute, floor of 1.
  def reading_minutes
    words = contents.sum { |c| c.value.to_s.split.size } + excerpt.to_s.split.size
    [ (words / 200.0).ceil, 1 ].max
  end

  def category_label
    I18n.t("journal.categories.#{category}")
  end

  private

  def derive_slugs
    self.slug_en = title_en.to_s.parameterize if slug_en.blank?
    if slug_ar.blank? && title_ar.present?
      # parameterize strips Arabic; keep Arabic letters, digits and dashes.
      self.slug_ar = title_ar.gsub(/[^\p{Arabic}a-z0-9\s-]/i, "").strip.gsub(/\s+/, "-").presence
    end
  end

  def localized_suffix
    I18n.locale == :ar ? "ar" : "en"
  end
end
