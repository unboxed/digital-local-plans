# frozen_string_literal: true

class TimetableExportsController < ApplicationController
  before_action :set_timetable

  def show
    csv_data = Timetables::BuildCsv.call(@timetable)

    send_data csv_data,
      filename: "timetable-#{@timetable.reference}-#{Date.current.iso8601}.csv",
      type: "text/csv"
  end

  private

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:timetable_id])
  end
end
