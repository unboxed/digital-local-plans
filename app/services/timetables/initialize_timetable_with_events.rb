# frozen_string_literal: true

module Timetables
  class InitializeTimetableWithEvents < ApplicationService
    def initialize(timetable:, form:)
      @timetable = timetable
      @form = form
    end

    def call
      Timetable.transaction do
        raise ActiveRecord::Rollback unless @form.save(@timetable)

        build_required_events
        true
      end || false
    end

    private

    def build_required_events
      TimetableEvent::REQUIRED_TIMETABLE_EVENTS.each_key do |event_key|
        @timetable.timetable_events.create!(
          plan_event: event_key,
          plan: @timetable.reference,
          status: :draft
        )
      end
    end
  end
end
