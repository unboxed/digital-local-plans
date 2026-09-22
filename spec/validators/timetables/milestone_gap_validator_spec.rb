# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::MilestoneGapValidator, type: :validator do
  describe "#check_gaps" do
    it "returns true if shorter gaps than required are found" do
      timetable = Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation)) # TODO: add events to factory
      required_gap = {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days, label: "21 days"}

      consultation_start_event = timetable.timetable_events.where(plan_event: "scoping-consultation-start")
      consultation_end_event = timetable.timetable_events.where(plan_event: "scoping-consultation-end")

      consultation_start_event.update!(event_date: Date.new(2030, 11, 1))
      consultation_end_event.update!(event_date: Date.new(2030, 11, 3))

      Timetables::MilestoneGapValidator.new.check_gaps(timetable, required_gap)

      expect(timetable.errors.full_messages).to include("There needs to be at least 21 days between Start Scoping Consultation and End Scoping Consultation")
    end

    it "returns no errors if no shorter gaps than required are found" do
      timetable = Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation))
      required_gap = {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days, label: "21 days"}

      consultation_start_event = timetable.timetable_events.where(plan_event: "scoping-consultation-start")
      consultation_end_event = timetable.timetable_events.where(plan_event: "scoping-consultation-end")

      consultation_start_event.update!(event_date: Date.new(2030, 11, 1))
      consultation_end_event.update!(event_date: Date.new(2030, 12, 25))

      Timetables::MilestoneGapValidator.new.check_gaps(timetable, required_gap)

      expect(timetable.errors.full_messages).to be_empty
    end

    it "returns no errors if one of the events in the comparison does not yet have a date" do
      timetable = Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation))
      required_gap = {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days, label: "21 days"}

      consultation_start_event = timetable.timetable_events.where(plan_event: "scoping-consultation-start")
      consultation_end_event = timetable.timetable_events.where(plan_event: "scoping-consultation-end")

      consultation_start_event.update!(event_date: Date.new(2030, 11, 1))
      consultation_end_event.update!(event_date: nil)

      Timetables::MilestoneGapValidator.new.check_gaps(timetable, required_gap)

      expect(timetable.errors.full_messages).to be_empty
    end
  end
end
