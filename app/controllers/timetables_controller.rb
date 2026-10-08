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
    @plan_duration = plan_duration
    @timetable_event_date_form = EditTimetableEventDateForm.new

    @milestone_options = TimetableEvent::REQUIRED_TIMETABLE_EVENTS.map do |key, attributes|
      MilestoneOption.new(id: key, name: attributes.fetch("name"))
    end
  end

  private

  def status
    STATUSES.fetch(@timetable.status)
  end

  def plan_duration
    commencement = @timetable.timetable_events.find_by(plan_event: 'gateway-1-self-assessment')
    adoption = @timetable.timetable_events.find_by(plan_event: 'adopted')

    start_date = commencement&.event_date
    end_date   = adoption&.event_date

    return unless start_date && end_date

    (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
  end

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:id])
  end
end
