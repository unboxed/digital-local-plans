# frozen_string_literal: true

FactoryBot.define do
  factory :timetable_event do
    association :timetable

    actual_date { Faker::Date.backward(days: 30) }
    entry_date { Faker::Date.backward(days: 365) }
    event_date { Faker::Date.forward(days: 60) }
    notes { Faker::Lorem.sentence }
    plan { "local-plan" }
    plan_event { TimetableEvent::TIMETABLE_EVENTS.sample }
    reference { Faker::Alphanumeric.alphanumeric(number: 8).upcase }

    trait :adopted do
      plan_event { "adopted" }
    end

    trait :examination_submitted do
      plan_event { "examination-submitted" }
    end

    trait :public_notice do
      plan_event { "public-notice-intention-commence" }
    end
  end
end
