# frozen_string_literal: true

module Timetables
  class InitializeTimetableWithEvents
    def self.call(organisation:)
      new(organisation: organisation).call
    end

    def initialize(organisation:)
      @organisation = organisation
    end

    def call
      timetable = @organisation.timetables.build(status: :draft)

      Timetable.transaction do
        timetable.save!
        build_required_events(timetable)
      end

      timetable
    rescue ActiveRecord::RecordInvalid
      timetable
    end

    private

    def build_required_events(timetable)
      TimetableEvent::REQUIRED_TIMETABLE_EVENTS.each do |event_key|
        timetable.timetable_events.create!(
          plan_event: event_key,
          status: :draft
        )
      end
    end
  end
end
