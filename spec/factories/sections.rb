FactoryBot.define do
  factory :section do
    sequence(:kind) { |n| "home_block_#{n}" }
    page { "home" }
    label { "A block" }
    position { 0 }
    settings { {} }
    items { [] }
  end
end
