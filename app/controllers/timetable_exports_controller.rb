# frozen_string_literal: true

require "zip"

class TimetableExportsController < ApplicationController
  before_action :set_timetable

  def show
    timetable_csv = Timetables::BuildTimetableCsv.call(@timetable)
    metadata_csv = Timetables::BuildMetadataCsv.call(@timetable)

    filename_prefix = "timetable-#{@timetable.reference}-#{Date.current.iso8601}"

    zip_data = Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry("#{filename_prefix}-data.csv")
      zip.write timetable_csv

      zip.put_next_entry("#{filename_prefix}-metadata.csv")
      zip.write metadata_csv
    end

    send_data zip_data.string,
      filename: "#{filename_prefix}.zip",
      type: "application/zip"
  end

  private

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:timetable_id])
  end
end
