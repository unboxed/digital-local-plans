# frozen_string_literal: true

class TimetableMetadataForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :reference, :string
  attribute :name, :string
  attribute :description, :string
  attribute :period_start_year, :integer
  attribute :period_end_year, :integer
  attribute :documentation_url, :string
  attribute :document_url, :string
  attribute :notes, :string

  validates :period_start_year, :period_end_year,
    numericality: {only_integer: true, in: 1900..2100, message: "Enter a year in the format YYYY, for example 2024"},
    allow_blank: true

  validate :end_year_not_before_start_year
  validate :end_year_in_future

  def self.build_from_timetable(timetable)
    new(
      reference: timetable&.reference,
      name: timetable&.name,
      description: timetable&.description,
      period_start_year: timetable&.period_start_year,
      period_end_year: timetable&.period_end_year,
      documentation_url: timetable&.documentation_url,
      document_url: timetable&.document_url,
      notes: timetable&.notes
    )
  end

  def save(timetable)
    return false unless valid?

    timetable.assign_attributes(attributes)
    return true if timetable.save

    errors.merge!(timetable.errors)
    false
  end

  private

  def end_year_in_future
    return if period_end_year.blank? || errors.include?(:period_end_year)
    return if period_end_year > Date.current.year

    errors.add(:period_end_year, "Plan period end year must be in the future")
  end

  def end_year_not_before_start_year
    return if period_start_year.blank? || period_end_year.blank?
    return if period_end_year >= period_start_year

    errors.add(:period_end_year, "Plan period end year must be the same as or after the start year")
  end
end
