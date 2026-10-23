# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :timetables, dependent: :destroy

  validates :name, presence: true

  def current_timetable
    timetables.last
    # timetable.upcoming.first
    # temporary change until we create initialisation form for timetable data
  end
end
