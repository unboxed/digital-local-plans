# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimetableEventForm do
  let(:form_class) do
    Class.new do
      include TimetableEventForm

      attr_accessor :name

      validates :name, presence: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "TestTimetableEventForm")
      end

      private

      def event_attributes
        {name:}
      end
    end
  end

  subject(:form) { form_class.new(name: "Updated") }

  let(:event) { instance_double(TimetableEvent, plan_event: "scoping-consultation-start", timetable:) }
  let(:timetable) { instance_double(Timetable, timetable_events:) }
  let(:timetable_events) { double("timetable_events", reload: nil) }
  let(:timetable_errors) { ActiveModel::Errors.new(timetable) }
  let(:timetable_warnings) { [] }

  before do
    allow(event).to receive(:update!)
    allow(timetable).to receive_messages(valid?: true, errors: timetable_errors, warnings: timetable_warnings)
  end

  describe "#save" do
    context "when the timetable has no errors or warnings" do
      it "updates the event with the form's event_attributes and returns true" do
        expect(form.save(event)).to be(true)
        expect(event).to have_received(:update!).with({name: "Updated"})
      end
    end

    context "when the form is invalid" do
      subject(:form) { form_class.new(name: nil) }

      it "returns false without updating the event" do
        expect(form.save(event)).to be(false)
        expect(event).not_to have_received(:update!)
      end
    end

    context "when the timetable has a gap error involving the event" do
      before do
        timetable_errors.add(:base, "There needs to be at least 21 days between things",
          from_key: "scoping-consultation-start", to_key: "scoping-consultation-end")
      end

      it "returns false and copies the error onto the form" do
        expect(form.save(event)).to be(false)
        expect(form.errors[:event_date]).to include("There needs to be at least 21 days between things")
      end
    end

    context "when the gap error is between other events" do
      before do
        timetable_errors.add(:base, "There needs to be at least 8 weeks between things",
          from_key: "proposed-plan-consultation-start", to_key: "proposed-plan-consultation-end")
      end

      it "ignores the error and returns true" do
        expect(form.save(event)).to be(true)
        expect(form.errors).to be_empty
      end
    end

    context "when the timetable has a gap warning involving the event" do
      let(:warning) do
        Timetables::MilestoneGapValidator::Warning.new(
          from_key: "scoping-consultation-start",
          to_key: "scoping-consultation-end",
          gap_label: "21 days",
          from_name: "Start Scoping Consultation",
          to_name: "End Scoping Consultation"
        )
      end
      let(:timetable_warnings) { [warning] }

      it "returns false and exposes the warning" do
        expect(form.save(event)).to be(false)
        expect(form.warnings).to eq([warning.message])
        expect(form.errors).to be_empty
      end

      context "and the warnings are confirmed" do
        subject(:form) { form_class.new(name: "Updated", warnings_confirmed: "true") }

        it "returns true" do
          expect(form.save(event)).to be(true)
        end
      end
    end
  end
end
