# frozen_string_literal: true

class TimetablesController < ApplicationController
  before_action :set_timetable, only: %i[show]

  STATUSES = {
    "draft" => {text: "In progress", colour: "blue"}
  }.freeze

  def index
    timetable = current_organisation.current_timetable ||
      Timetables::InitializeTimetableWithEvents.new(organisation: current_user.organisation).call

    redirect_to timetable_path(timetable)
  end

  def show
    @status = status
  end

  private

  def status
    STATUSES.fetch(@timetable.status)
  end

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:id])
  end
end
