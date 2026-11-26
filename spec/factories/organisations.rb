# frozen_string_literal: true

FactoryBot.define do
  factory :organisation do
    name { "Unboxed" }
    email { "dlp@unboxed.co" }

    initialize_with { Organisation.find_or_initialize_by(name:) }
  end
end
