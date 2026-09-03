# frozen_string_literal: true

FactoryBot.define do
  factory :timetable do
    association :organisation

    dataset { "local-plan" }
    description { Faker::Lorem.paragraph }
    document_url { Faker::Internet.url }
    documentation_url { Faker::Internet.url }
    entry_date { Faker::Date.backward(days: 365) }
    local_planning_authorities { "E07000223" }
    name { "#{Faker::Address.city} Local Plan" }
    notes { Faker::Lorem.sentence }
    period_start_date { "2027" }
    period_end_date { "2032" }
    reference { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
    required_housing { Faker::Number.between(from: 500, to: 10_000) }
  end
end
