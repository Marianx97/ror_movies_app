FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..12) }
    email { Faker::Internet.email }
    password { "StrongP@ssw0rd!" }
    password_confirmation { "StrongP@ssw0rd!" }
    isAdmin { false }

    trait :admin do
      isAdmin { true }
    end
  end
end
