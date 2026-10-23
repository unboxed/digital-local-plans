# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::MilestoneChronologyValidator, type: :validator do
  let(:timetable) { Timetables::InitializeTimetableWithEvents.call(organisation: create(:organisation)) }
  let(:error_message) { "There needs to be at least 21 days between Start Scoping Consultation and End Scoping Consultation" }

  describe "#validate" do
    context "When a mandatory milestone is out of the set chronology" do
      before { set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 8, 3)) }

      it "adds an error" do
        described_class.new.validate(timetable)

        expect(timetable.errors).to contain_exactly("End scoping consultation cannot come before Start scoping consultation")
      end
    end

    context "When all mandatory milestones are in the correct order" do
      before { set_scoping_consultation_dates(Date.new(2030, 11, 1), Date.new(2030, 11, 3)) }

      it "does not add an error" do
        described_class.new.validate(timetable)

        expect(timetable.errors).to be_empty
      end
    end
  end

  private

  def set_scoping_consultation_dates(start_date, end_date)
    timetable.timetable_events.where(plan_event: "scoping-consultation-start").update!(event_date: start_date)
    timetable.timetable_events.where(plan_event: "scoping-consultation-end").update!(event_date: end_date)
    timetable.reload
  end
end
