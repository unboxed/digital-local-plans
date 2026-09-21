# frozen_string_literal: true

class TimetablesController < ApplicationController
  before_action :set_timetable, only: %i[show export]

  STATUSES = {
    "draft" => {text: "In progress", colour: "blue"}
  }.freeze

  def index
    timetable = current_organisation.current_timetable ||
      Timetables::InitializeTimetableWithEvents.call(organisation: current_user.organisation)

    redirect_to timetable_path(timetable)
  end

  def show
    @status = status
  end

  def export
    csv_data = Timetables::BuildCsv.call(@timetable)

    send_data csv_data,
      filename: "timetable-#{@timetable.reference}-#{Date.current.iso8601}.csv",
      type: "text/csv"
  end

  private

  def status
    STATUSES.fetch(@timetable.status)
  end

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:id])
  end
end
