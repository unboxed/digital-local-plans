# frozen_string_literal: true

require "csv"

module Timetables
  class BuildCsv < ApplicationService
    HEADERS = %w[
      reference
      plan
      plan-event
      event-date
      actual-date
      entry-date
      notes
    ].freeze

    def initialize(timetable)
      @timetable = timetable
    end

    def call
      CSV.generate(headers: true) do |csv|
        csv << HEADERS

        events.each do |event|
          csv << [
            event.reference,
            event.plan,
            event.plan_event,
            event.event_date,
            event.actual_date,
            event.entry_date,
            event.notes
          ]
        end
      end
    end

    private

    def events
      @events ||= @timetable.timetable_events.order(:id)
    end
  end
end
