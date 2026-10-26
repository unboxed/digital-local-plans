# frozen_string_literal: true

require "rails_helper"
require "zip"

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

    it "returns zip content type" do
      get timetable_timetable_exports_path(timetable)

      expect(response.media_type).to eq("application/zip")
    end

    it "sets the expected zip filename" do
      get timetable_timetable_exports_path(timetable)

      expect(response.headers["Content-Disposition"])
        .to include("filename=\"timetable-LP-2050-#{Date.current.iso8601}.zip\"")
    end

    it "contains both data and metadata CSVs in the zip file" do
      get timetable_timetable_exports_path(timetable)

      filename_prefix = "timetable-LP-2050-#{Date.current.iso8601}"
      expected_data_csv = Timetables::BuildTimetableCsv.call(timetable)
      expected_metadata_csv = Timetables::BuildMetadataCsv.call(timetable)

      zip_entries = {}
      Zip::InputStream.open(StringIO.new(response.body)) do |io|
        while (entry = io.get_next_entry)
          zip_entries[entry.name] = io.read
        end
      end

      expect(zip_entries.keys).to contain_exactly(
        "#{filename_prefix}-data.csv",
        "#{filename_prefix}-metadata.csv"
      )
      expect(zip_entries["#{filename_prefix}-data.csv"]).to eq(expected_data_csv)
      expect(zip_entries["#{filename_prefix}-metadata.csv"]).to eq(expected_metadata_csv)
    end
  end
end
