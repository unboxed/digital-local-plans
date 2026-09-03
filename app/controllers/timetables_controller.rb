# frozen_string_literal: true

class TimetablesController < ApplicationController
  def index
    latest_timetable = current_user.organisation.timetables.order(created_at: :desc).first

    if latest_timetable
      redirect_to timetable_path(latest_timetable)
    else
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
