# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimetableEvent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:timetable) }
  end

  describe "callbacks" do
    describe "#set_entry_date" do
      it "sets entry_date on creation" do
        travel_to Date.new(2026, 9, 21) do
          event = create(:timetable_event)

          expect(event.entry_date).to eq(Date.new(2026, 9, 21))
        end
      end

      it "updates entry_date when another attribute changes" do
        event = create(:timetable_event, notes: "Initial note")

        travel_to 1.day.from_now do
          expect { event.update!(notes: "Updated note") }
            .to change(event, :entry_date).to(Date.current)
        end
      end

      it "does not update entry_date when nothing else has changed" do
        event = create(:timetable_event)

        travel_to 1.day.from_now do
          expect { event.save! }.not_to change(event, :entry_date)
        end
      end
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:status) }

    context "when in draft state" do
      subject { build(:timetable_event, status: :draft) }

      it { is_expected.to validate_presence_of(:plan_event) }

      it { is_expected.not_to validate_presence_of(:reference) }
      it { is_expected.not_to validate_presence_of(:entry_date) }
      it { is_expected.not_to validate_presence_of(:plan) }
    end

    context "when in published state" do
      subject { build(:timetable_event, status: :published) }

      it { is_expected.to validate_presence_of(:plan_event) }
      it { is_expected.to validate_presence_of(:reference) }
      it { is_expected.to validate_presence_of(:entry_date) }
      it { is_expected.to validate_presence_of(:plan) }
    end
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:status)
        .with_values(draft: "draft", published: "published")
        .backed_by_column_of_type(:string)
    }
  end

  describe "constants" do
    it "freezes the REQUIRED_TIMETABLE_EVENTS array" do
      expect(TimetableEvent::REQUIRED_TIMETABLE_EVENTS).to be_frozen
    end

    it "contains all expected baseline timetable events" do
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

      expect(TimetableEvent::REQUIRED_TIMETABLE_EVENTS).to match_array(expected_events)
    end
  end
end
