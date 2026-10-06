# frozen_string_literal: true

class TimetablesController < ApplicationController
  before_action :set_timetable, only: %i[show]

  MilestoneOption = Struct.new(:id, :name)

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
    @timetable_event_date_form = Turboframes::EditTimetableEventDateForm.new

    @milestone_options = TimetableEvent::REQUIRED_TIMETABLE_EVENTS.map do |key, attributes|
      MilestoneOption.new(id: key, name: attributes.fetch("name"))
    end
  end

  private

  def status
    STATUSES.fetch(@timetable.status)
  end

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:id])
  end
end
