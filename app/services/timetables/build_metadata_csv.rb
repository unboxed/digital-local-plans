# frozen_string_literal: true

require "csv"

module Timetables
  class BuildMetadataCsv < ApplicationService
    HEADERS = %w[
      reference
      name
      dataset
      description
      local-planning-authorities
      period-start-date
      period-end-date
      documentation-url
      document-url
      required-housing
      entry-date
      notes
    ].freeze

    def initialize(timetable)
      @timetable = timetable
    end

    def call
      CSV.generate(headers: true) do |csv|
        csv << HEADERS

        csv << [
          @timetable.reference,
          @timetable.name,
          @timetable.dataset,
          @timetable.description,
          @timetable.local_planning_authorities,
          @timetable.period_start_year,
          @timetable.period_end_year,
          @timetable.documentation_url,
          @timetable.document_url,
          @timetable.required_housing,
          @timetable.entry_date,
          @timetable.notes
        ]
      end
    end
  end
end
