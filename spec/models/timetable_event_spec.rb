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

  describe "adjacent milestones" do
    let(:timetable) { create(:timetable) }
    let(:keys) { TimetableEvent::REQUIRED_TIMETABLE_EVENTS.keys }

    def milestone_name(key)
      TimetableEvent::REQUIRED_TIMETABLE_EVENTS.dig(key, "name")
    end

    def create_event(key, event_date: nil, on: timetable)
      create(:timetable_event, timetable: on, plan_event: key, event_date: event_date)
    end

    context "when the event is in the middle of the list" do
      let(:previous_key) { keys[4] }
      let(:current_key) { keys[5] }
      let(:next_key) { keys[6] }

      it "returns the previous milestone with its planned date" do
        create_event(previous_key, event_date: Date.new(2027, 1, 15))
        event = create_event(current_key)

        expect(event.previous_milestone).to have_attributes(
          name: milestone_name(previous_key),
          event_date: Date.new(2027, 1, 15),
          dated?: true
        )
      end

      it "returns the next milestone with its planned date" do
        create_event(next_key, event_date: Date.new(2027, 6, 1))
        event = create_event(current_key)

        expect(event.next_milestone).to have_attributes(
          name: milestone_name(next_key),
          event_date: Date.new(2027, 6, 1),
          dated?: true
        )
      end

      it "returns an undated milestone when the neighbour has no planned date" do
        create_event(next_key, event_date: nil)
        event = create_event(current_key)

        expect(event.next_milestone).to have_attributes(
          name: milestone_name(next_key),
          event_date: nil,
          dated?: false
        )
      end

      it "returns an undated milestone when the neighbour event does not exist" do
        event = create_event(current_key)

        expect(event.previous_milestone).to have_attributes(
          name: milestone_name(previous_key),
          event_date: nil,
          dated?: false
        )
      end

      it "ignores events belonging to another timetable" do
        create_event(next_key, event_date: Date.new(2027, 6, 1), on: create(:timetable))
        event = create_event(current_key)

        expect(event.next_milestone.event_date).to be_nil
      end
    end

    context "when the event is the first milestone" do
      it "has no previous milestone" do
        event = create_event(keys.first)

        expect(event.previous_milestone).to be_nil
      end

      it "has a next milestone" do
        event = create_event(keys.first)

        expect(event.next_milestone.name).to eq(milestone_name(keys.second))
      end
    end

    context "when the event is the last milestone" do
      it "has no next milestone" do
        event = create_event(keys.last)

        expect(event.next_milestone).to be_nil
      end

      it "has a previous milestone" do
        event = create_event(keys.last)

        expect(event.previous_milestone.name).to eq(milestone_name(keys[-2]))
      end
    end

    context "when the plan_event is not a known milestone" do
      it "returns nil for both neighbours" do
        event = build(:timetable_event, plan_event: "not-a-real-milestone")

        expect(event.previous_milestone).to be_nil
        expect(event.next_milestone).to be_nil
      end
    end
  end
end
