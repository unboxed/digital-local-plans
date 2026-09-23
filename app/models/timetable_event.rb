# frozen_string_literal: true

class TimetableEvent < ApplicationRecord
  before_save :set_entry_date, unless: :new_record?

  belongs_to :timetable

  REQUIRED_TIMETABLE_EVENTS = YAML.load_file(
    Rails.root.join("config/timetable_milestones.yml")
  ).freeze

  enum :status, {
    draft: "draft",
    published: "published"
  }, default: "draft"

  validates :status, presence: true
  validates :plan_event, presence: true

  with_options unless: :draft? do
    validates :reference, :entry_date, :plan, presence: true
  end

  def milestone_name
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "name")
  end

  def timing_description
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "timing_description")
  end

  def set_entry_date
    self.entry_date = Date.current if (changed - ["entry_date"]).any?
  end
end
