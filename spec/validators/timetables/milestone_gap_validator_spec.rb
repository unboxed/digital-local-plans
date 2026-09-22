# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::MilestoneGapValidator, type: :validator do
  describe "#check_for_short_gaps" do
    it "returns true if shorter gaps than required are found" do
      timetable = Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation)) # TODO: add events to factory
      required_gap = {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days}

      consultation_start_event = timetable.timetable_events.where(plan_event: "scoping-consultation-start")
      consultation_end_event = timetable.timetable_events.where(plan_event: "scoping-consultation-end")

      consultation_start_event.update!(event_date: Date.new(2030, 11, 1))
      consultation_end_event.update!(event_date: Date.new(2030, 11, 3))

      expect(Timetables::MilestoneGapValidator.new.check_for_short_gaps(timetable, required_gap)).to be true
    end

    it "returns nil if no shorter gaps than required are found" do
      timetable = Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation))
      required_gap = {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days}

      consultation_start_event = timetable.timetable_events.where(plan_event: "scoping-consultation-start")
      consultation_end_event = timetable.timetable_events.where(plan_event: "scoping-consultation-end")

      consultation_start_event.update!(event_date: Date.new(2030, 11, 1))
      consultation_end_event.update!(event_date: Date.new(2030, 12, 25))

      expect(Timetables::MilestoneGapValidator.new.check_for_short_gaps(timetable, required_gap)).to be nil
    end

    it "returns nil without throwing an error if one of the events in the comparison does not yet have a date" do
      timetable = Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation))
      required_gap = {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days}

      consultation_start_event = timetable.timetable_events.where(plan_event: "scoping-consultation-start")
      consultation_end_event = timetable.timetable_events.where(plan_event: "scoping-consultation-end")

      consultation_start_event.update!(event_date: Date.new(2030, 11, 1))
      consultation_end_event.update!(event_date: nil)

      expect(Timetables::MilestoneGapValidator.new.check_for_short_gaps(timetable, required_gap)).to be nil
    end
  end
end
