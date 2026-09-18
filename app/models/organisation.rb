# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :timetables, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}

  def current_timetable
    timetables.upcoming.first
  end
end
