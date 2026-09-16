# frozen_string_literal: true

class TimetableEventsController < ApplicationController
  before_action :set_timetable_event

  def edit
    @humanized_event_name = @timetable_event.plan_event.tr("-", " ").humanize
  end

  def update
  end

private

  def set_timetable_event
    @timetable_event = current_user.organisation.timetables.last.timetable_events.find(params[:id])
  end
end
