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
    period_start_year { Date.current.year }
    period_end_year { Date.current.year + 15 }
    reference { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
    required_housing { Faker::Number.between(from: 500, to: 10_000) }

    trait :with_required_events do
      after(:create) do |timetable|
        TimetableEvent::REQUIRED_TIMETABLE_EVENTS.each_key do |event_key|
          timetable.timetable_events.create!(
            plan_event: event_key,
            plan: timetable.reference,
            status: :draft
          )
        end
      end
    end
  end
end
