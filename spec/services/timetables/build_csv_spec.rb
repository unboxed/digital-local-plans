# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetables::BuildCsv, type: :service do
  let(:timetable) { create(:timetable, name: "City of London Plan") }

  subject(:build_csv) { described_class.call(timetable) }

  let!(:event_1) do
    create(
      :timetable_event,
      timetable:,
      reference: "LP-101",
      plan: "Local Plan 2030",
      plan_event: "Public-notice-intention-commence",
      event_date: Date.new(2030, 9, 14),
      actual_date: Date.new(2030, 9, 14),
      entry_date: Date.new(2026, 9, 21),
      notes: "First milestone note"
    )
  end

  describe "#call" do
    it "returns CSV string with headers and event rows" do
      csv = CSV.parse(build_csv)

      expect(csv[0]).to eq(%w[
        reference
        plan
        plan-event
        event-date
        actual-date
        entry-date
        notes
      ])

      expect(csv[1]).to eq([
        "LP-101",
        "Local Plan 2030",
        "Public-notice-intention-commence",
        "2030-09-14",
        "2030-09-14",
        "2026-09-21",
        "First milestone note"
      ])
    end
  end
end
