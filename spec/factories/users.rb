FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "editor#{n}@neuskin.test" }
    password { "password123" }
    role { "editor" }

    factory :admin_user do
      role { "admin" }
    end
  end
end
