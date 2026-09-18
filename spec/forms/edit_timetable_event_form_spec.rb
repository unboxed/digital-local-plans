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

  describe "validations" do
    it { is_expected.to validate_presence_of(:reference) }

    describe "#validate_event_date" do
      context "when event_date fields are missing" do
        let(:form) { described_class.new(valid_attributes.merge(event_date_day: nil)) }

        it "is invalid and adds a blank error" do
          expect(form).to be_invalid
          expect(form.errors[:event_date]).to include("Enter a planned date")
        end
      end

      context "when event_date contains an invalid date value" do
        let(:form) do
          described_class.new(
            valid_attributes.merge(event_date_day: "1", event_date_month: "February", event_date_year: "2028")
          )
        end

        it "is invalid and adds an invalid error" do
          expect(form).to be_invalid
          expect(form.errors[:event_date]).to include("Enter a valid planned date")
        end
      end
    end

    describe "#validate_future_and_max_dates" do
      context "when event_date is in the past" do
        let(:form) do
          described_class.new(
            valid_attributes.merge(event_date_day: "1", event_date_month: "1", event_date_year: "2020")
          )
        end

        it "is invalid and adds a not_in_future error" do
          expect(form).to be_invalid
          expect(form.errors[:event_date]).to include("The planned date must be in the future")
        end
      end

      context "when event_date year is greater than 2050" do
        let(:form) do
          described_class.new(
            valid_attributes.merge(event_date_day: "1", event_date_month: "1", event_date_year: "2051")
          )
        end

        it "is invalid and adds a too_far_in_future error" do
          expect(form).to be_invalid
          expect(form.errors[:event_date]).to include("The planned date must be before 2050")
        end
      end

      context "when event_date is valid and in the future" do
        it "is valid" do
          expect(form).to be_valid
        end
      end
    end
  end

  describe "date parsing helper methods" do
    it "parses #event_date correctly" do
      expect(form.event_date).to eq(Date.new(2028, 10, 20))
    end

    it "parses #actual_date correctly" do
      expect(form.actual_date).to eq(Date.new(2028, 10, 15))
    end

    it "parses #entry_date correctly" do
      expect(form.entry_date).to eq(Date.new(2028, 10, 10))
    end

    context "when optional date components are missing" do
      let(:form) { described_class.new(valid_attributes.merge(actual_date_day: nil)) }

      it "returns nil for that date" do
        expect(form.actual_date).to be_nil
      end
    end
  end

  describe ".build_from_event" do
    let(:event) do
      double(
        "Event",
        reference: "REF-999",
        notes: "Existing notes",
        event_date: Date.new(2027, 5, 12),
        actual_date: Date.new(2027, 5, 10),
        entry_date: nil
      )
    end

    subject(:built_form) { described_class.build_from_event(event) }

    it "initializes the form with attributes extracted from the event" do
      expect(built_form.reference).to eq("REF-999")
      expect(built_form.notes).to eq("Existing notes")
      expect(built_form.event_date_day).to eq(12)
      expect(built_form.event_date_month).to eq(5)
      expect(built_form.event_date_year).to eq(2027)
      expect(built_form.actual_date_day).to eq(10)
      expect(built_form.actual_date_month).to eq(5)
      expect(built_form.actual_date_year).to eq(2027)
      expect(built_form.entry_date_day).to be_nil
    end
  end

  describe "#save" do
    let(:event) { instance_double("TimetableEvent") }

    context "when the form is valid" do
      it "updates the event and returns true" do
        expect(event).to receive(:update!).with(
          reference: "LP-101",
          notes: "This is my local plan milestone",
          event_date: Date.new(2028, 10, 20),
          actual_date: Date.new(2028, 10, 15),
          entry_date: Date.new(2028, 10, 10)
        ).and_return(true)

        expect(form.save(event)).to be_truthy
      end
    end

    context "when the form is invalid" do
      let(:form) { described_class.new(valid_attributes.merge(reference: nil)) }

      it "returns false and does not update the event" do
        expect(event).not_to receive(:update!)
        expect(form.save(event)).to be(false)
      end
    end
  end
end
