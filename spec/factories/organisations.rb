# frozen_string_literal: true

FactoryBot.define do
  factory :organisation do
    name { "Unboxed" }
    email { "dlp@unboxed.co" }

    initialize_with { Organisation.find_or_create_by(email:) }
  end
end
