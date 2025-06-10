FactoryBot.define do
  factory :movie do
    title         { Faker::Movie.title }
    description   { Faker::Lorem.paragraph_by_chars(number: 200) }
    director      { Faker::Name.first_name }
    producer      { Faker::Name.first_name }
    release_date  { Faker::Date.between(from: '1900-01-01', to: Date.today) }
  end
end
