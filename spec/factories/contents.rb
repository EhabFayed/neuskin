FactoryBot.define do
  factory :content do
    association :parentable, factory: :section
    sequence(:key) { |n| "field_#{n}" }
    label { "A field" }
    value_en { "English" }
    value_ar { "عربى" }
    content_type { "text" }
    position { 0 }
  end
end
