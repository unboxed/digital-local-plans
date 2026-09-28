# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::MilestoneGapValidator, type: :validator do
  let(:timetable) { Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation)) } # TODO: add events to factory
  let(:error_message) { "There needs to be at least 21 days between Start Scoping Consultation and End Scoping Consultation" }

  describe "#validate" do
    context "when the gap is shorter than required" do
      before { set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 11, 3)) }

      it "adds an error by default" do
        described_class.new.validate(timetable)

        expect(timetable.errors.full_messages).to include(error_message)
        expect(timetable.warnings).to be_empty
      end

      it "adds a warning instead when initialised with warning: true" do
        described_class.new(warning: true).validate(timetable)

        expect(timetable.errors).to be_empty
        expect(timetable.warnings).to contain_exactly(
          have_attributes(
            from_key: "scoping-consultation-start",
            to_key: "scoping-consultation-end",
            gap_label: "21 days",
            from_name: "Start Scoping Consultation",
            to_name: "End Scoping Consultation"
          )
        )
      end
    end

    context "when the gap is long enough" do
      before { set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 12, 25)) }

      it "adds no errors or warnings" do
        described_class.new.validate(timetable)
        described_class.new(warning: true).validate(timetable)

        expect(timetable.errors).to be_empty
        expect(timetable.warnings).to be_empty
      end
    end

    context "when one of the events does not yet have a date" do
      before { set_scoping_consultation_dates(Date.new(2030, 11, 1), nil) }

      it "adds no errors or warnings" do
        described_class.new.validate(timetable)
        described_class.new(warning: true).validate(timetable)

        expect(timetable.errors).to be_empty
        expect(timetable.warnings).to be_empty
      end
    end
  end

  private

  def set_scoping_consultation_dates(start_date, end_date)
    timetable.timetable_events.where(plan_event: "scoping-consultation-start").update!(event_date: start_date)
    timetable.timetable_events.where(plan_event: "scoping-consultation-end").update!(event_date: end_date)
  end
end
