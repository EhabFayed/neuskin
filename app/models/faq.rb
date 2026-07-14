# A question on the FAQ page — dynamic counterpart of the old fixed
# faq/faq_items section keys (top_brand has the same standalone Faq model).
class Faq < ApplicationRecord
  extend Enumerize

  # The page's three editorial groups, in display order.
  enumerize :category, in: %i[before_you_come_in how_care_works privacy],
                       default: :before_you_come_in, scope: true

  validates :question_en, :question_ar, :answer_en, :answer_ar, presence: true

  default_scope { order(:position) }

  # Groups in enum order, only those that have questions:
  # [[:before_you_come_in, [faq, …]], …]
  def self.grouped
    by_cat = all.group_by { |f| f.category.to_s }
    category.values.filter_map { |cat| [cat, by_cat[cat.to_s]] if by_cat[cat.to_s] }
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
