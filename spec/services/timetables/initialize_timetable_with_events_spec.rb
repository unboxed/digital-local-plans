# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::InitializeTimetableWithEvents, type: :service do
  let(:organisation) { create(:organisation) }

  describe ".call" do
    subject(:service_call) { described_class.call(organisation: organisation) }

    it "initializes an empty draft timetable linked to the organisation" do
      expect { service_call }.to change(Timetable, :count).by(1)

      timetable = Timetable.last
      expect(timetable.organisation).to eq(organisation)
      expect(timetable.status).to eq("draft")
      expect(timetable.name).to be_nil
    end

    it "seeds all 12 mandatory events in draft status with plan_event populated" do
      expect { service_call }.to change(TimetableEvent, :count).by(12)

      timetable = Timetable.last
      events = timetable.timetable_events

      expect(events.pluck(:plan_event)).to match_array(TimetableEvent::REQUIRED_TIMETABLE_EVENTS)
      expect(events.pluck(:status).uniq).to eq(["draft"])
      expect(events.pluck(:reference).compact).to be_empty
    end
  end
end
