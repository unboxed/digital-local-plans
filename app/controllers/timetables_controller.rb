# frozen_string_literal: true

class TimetablesController < ApplicationController
  before_action :set_timetable, only: %i[show]

  def index
    timetable = current_user.organisation.timetables.draft.order(created_at: :desc).first ||
      Timetables::InitializeTimetableWithEvents.new(organisation: current_user.organisation).call

    redirect_to timetable_path(timetable)
  end

  def show
  end

  private

  def set_timetable
    @timetable = current_user.organisation.timetables.find(params[:id])
  end
end
