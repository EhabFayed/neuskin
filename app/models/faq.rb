# A question on the FAQ page — dynamic counterpart of the old fixed
# faq/faq_items section keys (top_brand has the same standalone Faq model).
class Faq < ApplicationRecord
  extend Enumerize

  # The page's three editorial groups, in display order.
  enumerize :category, in: %i[before_you_come_in how_care_works privacy],
                       default: :before_you_come_in, scope: true

  validates :question_en, :question_ar, :answer_en, :answer_ar, presence: true

  default_scope { order(:position) }

  # Where a question shows: the /faq page (on_faq_page, grouped by category)
  # and/or other pages via placements, e.g. "protocol:neuskin-method". One
  # question, written once, reused wherever it is placed.
  scope :on_faq_page, -> { where(on_faq_page: true) }
  scope :placed_on, ->(key) { where("placements @> ?", [ key.to_s ].to_json) }

  # The pages a question can be placed on: [["The NeuSkin Method", "protocol:neuskin-method"], …]
  def self.placement_options
    Protocol.all.map { |p| [ "Protocol · #{p.name_en}", "protocol:#{p.slug}" ] }
  end

  def placements=(list)
    super(Array(list).map(&:to_s).map(&:strip).reject(&:blank?).uniq)
  end

  def placed_on?(key) = placements.include?(key.to_s)

  # Groups in enum order, only those that have questions:
  # [[:before_you_come_in, [faq, …]], …]
  def self.grouped
    by_cat = on_faq_page.group_by { |f| f.category.to_s }
    category.values.filter_map { |cat| [ cat, by_cat[cat.to_s] ] if by_cat[cat.to_s] }
  end

  # Locale-aware readers (question -> question_ar / question_en).
  %i[question answer].each do |attr|
    define_method(attr) do
      public_send("#{attr}_#{localized_suffix}")
    end
  end

  def category_label
    I18n.t("faq.groups.#{category}")
  end

  private

  def localized_suffix
    I18n.locale == :ar ? "ar" : "en"
  end
end
