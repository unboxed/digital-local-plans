# frozen_string_literal: true

namespace :organisations do
  desc "Import planning authorities from planning.data.gov.uk"
  task import: :environment do
    count = Organisations::ImportFromPlanningData.call
    puts "Imported #{count} organisations"
  end
end
