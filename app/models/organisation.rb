# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :timetables, dependent: :destroy

  normalizes :name, with: ->(name) { name.squish }

  validates :name, presence: true

  scope :active, -> { where.not(reference: nil).where(end_date: [nil, Date.current..]) }
  
  def current_timetable
    timetables.order(:created_at).last
  end
end
