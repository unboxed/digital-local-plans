# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimetableEvent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:timetable) }
  end

  describe "callbacks" do
    describe "#set_entry_date" do
      it "does not set entry_date on creation" do
        event = create(:timetable_event, entry_date: nil)
        expect(event.entry_date).to be_nil
      end

      it "sets entry_date to today when another attribute is later updated" do
        event = create(:timetable_event, entry_date: nil)

        travel_to(Date.new(2026, 9, 21)) do
          expect { event.update!(notes: "Updated note") }.to change(event, :entry_date).to(Date.new(2026, 9, 21))
        end
      end

      it "updates entry_date again on a further edit" do
        event = create(:timetable_event, entry_date: Date.new(2026, 1, 1))

        travel_to(Date.new(2026, 9, 21)) do
          expect { event.update!(notes: "Another edit") }.to change(event, :entry_date).to(Date.new(2026, 9, 21))
        end
      end

      it "does not update entry_date if nothing else has changed" do
        event = create(:timetable_event, entry_date: Date.new(2026, 1, 1))

        travel_to(Date.new(2026, 9, 21)) do
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

  describe "required_events" do
    it "freezes the REQUIRED_TIMETABLE_EVENTS hash" do
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

      expect(TimetableEvent::REQUIRED_TIMETABLE_EVENTS.keys).to match_array(expected_events)
    end

    it "has a name and timing description for every required event" do
      TimetableEvent::REQUIRED_TIMETABLE_EVENTS.each_value do |data|
        expect(data["name"]).to be_present
        expect(data["timing_description"]).to be_present
      end
    end
  end
end
