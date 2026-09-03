# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimetableEvent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:timetable) }
  end

  describe "validations" do
    subject { build(:timetable_event) }

    it { is_expected.to validate_presence_of(:plan_event) }
    it { is_expected.to validate_presence_of(:reference) }
    it { is_expected.to validate_presence_of(:event_date) }
    it { is_expected.to validate_presence_of(:entry_date) }

    it { is_expected.to validate_inclusion_of(:plan_event).in_array(TimetableEvent::TIMETABLE_EVENTS) }
  end

  describe "constants" do
    it "freezes the TIMETABLE_EVENTS array" do
      expect(TimetableEvent::TIMETABLE_EVENTS).to be_frozen
    end

    it "contains all expected timetable events" do
      expected_events = %w[
        public-notice-intention-commence
        scoping-consultation-start
        scoping-consultation-end
        gateway-1-self-assessment
        plan-content-evidence-consultation-start
        plan-content-evidence-consultation-end
        gateway-2-advice-sought
        proposed-plan-consultation-start
        proposed-plan-consultation-end
        gateway-3-advice-sought
        examination-submitted
        adopted
      ]

      expect(TimetableEvent::TIMETABLE_EVENTS).to match_array(expected_events)
    end
  end
end
