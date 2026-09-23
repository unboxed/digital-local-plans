# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Timetables::Export", type: :request do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisation:) }
  let(:timetable) { create(:timetable, organisation:, reference: "LP-2050") }

  before do
    sign_in user
    create_list(:timetable_event, 2, timetable:)
  end

  describe "GET /timetables/:timetable_id/timetable_exports" do
    it "returns a successful response" do
      get timetable_timetable_exports_path(timetable)

      expect(response).to have_http_status(:ok)
    end

    it "returns CSV content type" do
      get timetable_timetable_exports_path(timetable)

      expect(response.content_type).to eq("text/csv")
    end

    it "sets the expected filename" do
      get timetable_timetable_exports_path(timetable)

      expect(response.headers["Content-Disposition"])
        .to include("timetable-LP-2050-#{Date.current.iso8601}.csv")
    end

    it "returns the generated CSV data" do
      get timetable_timetable_exports_path(timetable)

      expect(response.body).to eq(Timetables::BuildCsv.call(timetable))
    end
  end
end
