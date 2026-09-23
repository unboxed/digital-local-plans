# frozen_string_literal: true

module Timetables
  class MilestoneGapValidator < ActiveModel::Validator
    REQUIRED_GAPS = [
      {from: "scoping-consultation-start", to: "scoping-consultation-end", minimum_gap: 21.days, label: "21 days"},
      {from: "public-notice-intention-commence", to: "gateway-1-self-assessment", minimum_gap: 4.months, label: "4 months"},
      {from: "plan-content-evidence-consultation-start", to: "plan-content-evidence-consultation-end", minimum_gap: 6.weeks, label: "6 weeks"},
      {from: "proposed-plan-consultation-start", to: "proposed-plan-consultation-end", minimum_gap: 8.weeks, label: "8 weeks"}
      # TODO: Add ability to validate for maximum_gap between scoping-consultation-start and adoption
    ].freeze

    def validate(timetable)
      REQUIRED_GAPS.each do |required_gap|
        check_gaps(timetable, required_gap)
      end
    end

    def check_gaps(timetable, required_gap)
      from_event = find_event(timetable, required_gap[:from])
      to_event = find_event(timetable, required_gap[:to])
      return unless from_event.event_date && to_event.event_date

      actual_gap = calculate_gap_between(from_event, to_event)
      return if actual_gap >= required_gap[:minimum_gap]

      timetable.errors.add(
        :base,
        :insufficient_gap,
        from_key: required_gap[:from],
        to_key: required_gap[:to],
        gap_label: required_gap[:label],
        from_name: from_event.milestone_name.titleize,
        to_name: to_event.milestone_name.titleize
      )
    end

    private

    def find_event(timetable, plan_event_key)
      timetable.timetable_events.find { |timetable_event| timetable_event.plan_event == plan_event_key }
    end

    def calculate_gap_between(from_event, to_event)
      (to_event.event_date - from_event.event_date).to_i.days
    end
  end
end
