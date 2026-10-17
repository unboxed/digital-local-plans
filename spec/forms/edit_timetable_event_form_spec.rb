# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditTimetableEventForm, type: :model do
  subject(:form) { described_class.new(valid_attributes) }

  let(:valid_attributes) do
    {
      reference: "LP-101",
      notes: "This is my local plan milestone",
      event_date_day: "20",
      event_date_month: "10",
      event_date_year: "2028",
      actual_date_day: "15",
      actual_date_month: "10",
      actual_date_year: "2028",
      entry_date_day: "10",
      entry_date_month: "10",
      entry_date_year: "2028"
    }
  end

  describe "#save" do
    let(:event) { instance_double(TimetableEvent, plan_event: "scoping-consultation-start", timetable:) }
    let(:timetable) do
      instance_double(Timetable, timetable_events: double(reload: nil), valid?: true,
        errors: ActiveModel::Errors.new(Timetable.new), warnings: [])
    end

    it "updates the event with all the form's fields" do
      allow(event).to receive(:update!)

      form.save(event)

      expect(event).to have_received(:update!).with({
        reference: "LP-101",
        notes: "This is my local plan milestone",
        event_date: Date.new(2028, 10, 20),
        actual_date: Date.new(2028, 10, 15),
        entry_date: Date.new(2028, 10, 10)
      })
    end
  end
end
