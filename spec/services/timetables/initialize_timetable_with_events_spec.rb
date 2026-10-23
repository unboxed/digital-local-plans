# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::InitializeTimetableWithEvents, type: :service do
  let(:organisation) { create(:organisation) }
  let(:timetable) { organisation.timetables.build(status: :draft) }
  let(:form) { instance_double(TimetableMetadataForm) }

  describe ".call" do
    subject(:service_call) { described_class.call(timetable:, form:) }

    context "when the form saves" do
      before { allow(form).to receive(:save) { |t| t.save } }

      it "returns true" do
        expect(service_call).to be(true)
      end

      it "creates a draft timetable linked to the organisation" do
        expect { service_call }.to change(Timetable, :count).by(1)

        expect(timetable.organisation).to eq(organisation)
        expect(timetable.status).to eq("draft")
        expect(timetable.name).to be_nil
      end

      it "seeds all mandatory events in draft status with plan_event populated" do
        expect { service_call }.to change(TimetableEvent, :count).by(TimetableEvent::REQUIRED_TIMETABLE_EVENTS.size)

        events = timetable.timetable_events

        expect(events.pluck(:plan_event)).to match_array(TimetableEvent::REQUIRED_TIMETABLE_EVENTS.keys)
        expect(events.pluck(:status).uniq).to eq(["draft"])
        expect(events.pluck(:reference).compact).to be_empty
      end
    end

    context "when the form does not save" do
      before { allow(form).to receive(:save).and_return(false) }

      it "returns false and creates nothing" do
        expect { expect(service_call).to be(false) }
          .to not_change(Timetable, :count)
          .and not_change(TimetableEvent, :count)
      end
    end
  end
end
