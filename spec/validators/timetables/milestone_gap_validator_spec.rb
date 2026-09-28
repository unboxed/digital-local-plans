# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::MilestoneGapValidator, type: :validator do
  let(:timetable) { Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation)) } # TODO: add events to factory
  let(:required_gap) { {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days, label: "21 days"} }
  let(:error_message) { "There needs to be at least 21 days between Start Scoping Consultation and End Scoping Consultation" }

  describe "#validate" do
    before { set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 11, 3)) }

    it "adds errors by default" do
      described_class.new.validate(timetable)

      expect(timetable.errors.full_messages).to include(error_message)
      expect(timetable.warnings).to be_empty
    end

    it "adds warnings when initialised with warning: true" do
      described_class.new(warning: true).validate(timetable)

      expect(timetable.errors).to be_empty
      expect(timetable.warnings.map(&:gap_label)).to eq(["21 days"])
    end
  end

  describe "#check_gaps" do
    context "when warning is false" do
      it "adds an error if the gap is shorter than required" do
        set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 11, 3))

        described_class.new.check_gaps(timetable, required_gap, warning: false)

        expect(timetable.errors.full_messages).to include(error_message)
        expect(timetable.warnings).to be_empty
      end

      it "adds no errors if the gap is long enough" do
        set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 12, 25))

        described_class.new.check_gaps(timetable, required_gap, warning: false)

        expect(timetable.errors).to be_empty
      end

      it "adds no errors if one of the events does not yet have a date" do
        set_scoping_consultation_dates(Date.new(2030, 11, 1), nil)

        described_class.new.check_gaps(timetable, required_gap, warning: false)

        expect(timetable.errors).to be_empty
      end
    end

    context "when warning is true" do
      it "adds a warning instead of an error if the gap is shorter than required" do
        set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 11, 3))

        described_class.new.check_gaps(timetable, required_gap, warning: true)

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

      it "adds no warnings if the gap is long enough" do
        set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 12, 25))

        described_class.new.check_gaps(timetable, required_gap, warning: true)

        expect(timetable.warnings).to be_empty
      end

      it "adds no warnings if one of the events does not yet have a date" do
        set_scoping_consultation_dates(Date.new(2030, 11, 1), nil)

        described_class.new.check_gaps(timetable, required_gap, warning: true)

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
