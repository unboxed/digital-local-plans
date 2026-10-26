# frozen_string_literal: true

class TimetableEvent < ApplicationRecord
  after_initialize :prefill_reference, if: :new_record?
  before_save :set_entry_date, unless: :new_record?

  belongs_to :timetable

  REQUIRED_TIMETABLE_EVENTS = YAML.load_file(
    Rails.root.join("config/required_timetable_events.yml")
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

  AdjacentMilestone = Data.define(:name, :event_date) do
    def dated? = event_date.present?
  end

  def previous_milestone
    adjacent_milestone(-1)
  end

  def next_milestone
    adjacent_milestone(1)
  end

  def milestone_name
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "name")
  end

  def event_reference
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "reference")
  end

  def timing_description
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "timing_description")
  end

  def set_entry_date
    self.entry_date = Date.current if (changed - ["entry_date"]).any?
  end

  def prefill_reference
    return if timetable&.reference.blank?

    self.reference = "#{timetable.reference}-#{event_reference}"
  end

  private

  def adjacent_milestone(offset)
    index = REQUIRED_TIMETABLE_EVENTS.keys.index(plan_event)
    return if index.nil?

    neighbour_index = index + offset
    return if neighbour_index.negative?

    key = REQUIRED_TIMETABLE_EVENTS.keys[neighbour_index]
    return if key.nil?

    event = timetable.timetable_events.find { |e| e.plan_event == key }

    AdjacentMilestone.new(
      name: REQUIRED_TIMETABLE_EVENTS.dig(key, "name"),
      event_date: event&.event_date
    )
  end
end
