# frozen_string_literal: true

require "csv"
require "open-uri"

module Organisations
  class ImportFromPlanningData < ApplicationService
    class ImportError < StandardError; end

    BASE_URL = "https://files.planning.data.gov.uk/dataset"
    DATASETS = %w[local-authority national-park-authority].freeze
    REQUIRED_HEADERS = %w[dataset reference name local-planning-authority end-date].freeze
    MINIMUM_EXPECTED = 300

    def initialize(minimum: MINIMUM_EXPECTED)
      @minimum = minimum
    end

    def call
      records = DATASETS.flat_map { |dataset| parse(fetch("#{BASE_URL}/#{dataset}.csv")) }

      if records.size < @minimum
        raise ImportError, "Only #{records.size} organisations found, expected at least #{@minimum}"
      end

      Organisation.upsert_all(records, unique_by: :reference)
      records.size
    end

    private

    def fetch(url)
      URI.parse(url).open(open_timeout: 10, read_timeout: 30).read
    end

    def parse(csv)
      table = CSV.parse(csv, headers: true)

      missing = REQUIRED_HEADERS - table.headers
      raise ImportError, "CSV missing columns: #{missing.join(", ")}" if missing.any?

      table.filter_map do |row|
        next if row["local-planning-authority"].blank?

        {
          name: row["name"].squish,
          reference: "#{row["dataset"]}:#{row["reference"]}",
          local_planning_authority: row["local-planning-authority"],
          end_date: row["end-date"].presence
        }
      end
    end
  end
end
