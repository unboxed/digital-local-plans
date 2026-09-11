# frozen_string_literal: true

class TimetablesController < ApplicationController
  def index
    timetable = current_user.organisation.timetables.draft.order(created_at: :desc).first
    # TODO: || Timetables::CreateService.call(organisation: current_user.organisation)

    if timetable
      redirect_to timetable_path(timetable)
    else
      # Fallback until CreateService is ready
      redirect_to new_timetable_path
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_timetable
  end

  def timetable_params
  end
end
