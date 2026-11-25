# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :timetables, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  normalizes :name, with: ->(name) { name.squish }

  def self.find_or_initialize_by_name(name)
    name = name.to_s.squish
    where("LOWER(name) = ?", name.downcase).first_or_initialize(name:)
  end

  def current_timetable
    timetables.order(:created_at).last
  end
end
