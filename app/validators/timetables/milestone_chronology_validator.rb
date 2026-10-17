# frozen_string_literal: true

module Timetables
  class MilestoneChronologyValidator < ActiveModel::Validator
    def validate(timetable)
      dated_events = milestones.keys.filter_map do |key|
        timetable.timetable_events.find { |event| event.plan_event == key && event.event_date }
      end

      dated_events.each_cons(2) do |earlier, later|
        next unless later.event_date < earlier.event_date

        timetable.errors.add(
          :base,
          :out_of_chronology,
          from_key: earlier.plan_event,
          to_key: later.plan_event,
          from_name: milestones.dig(earlier.plan_event, "name"),
          to_name: milestones.dig(later.plan_event, "name")
        )
      end
    end

    def milestones
      TimetableEvent::REQUIRED_TIMETABLE_EVENTS
    end
  end
end
