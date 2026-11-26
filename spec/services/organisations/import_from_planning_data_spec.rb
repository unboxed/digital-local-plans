# frozen_string_literal: true

require "rails_helper"

RSpec.describe Organisations::ImportFromPlanningData do
  let(:local_authority_csv) do
    <<~CSV
      dataset,end-date,name,reference,local-planning-authority
      local-authority,,New Forest District Council,NEW,E60000249
      local-authority,2023-03-31,Allerdale Borough Council,ALL,E60000019
      local-authority,,Hampshire County Council,HAM,
    CSV
  end

  let(:national_park_csv) do
    <<~CSV
      dataset,end-date,name,reference,local-planning-authority
      national-park-authority,,New Forest National Park Authority,Q72617158,E60000321
    CSV
  end

  def stub_dataset(dataset, **response)
    stub_request(:get, "#{described_class::BASE_URL}/#{dataset}.csv").to_return(**response)
  end

  def import(minimum: 1)
    described_class.call(minimum:)
  end

  before do
    stub_dataset("local-authority", body: local_authority_csv)
    stub_dataset("national-park-authority", body: national_park_csv)
  end

  it "imports planning authorities from both datasets" do
    import

    expect(Organisation.pluck(:name)).to contain_exactly(
      "New Forest District Council",
      "Allerdale Borough Council",
      "New Forest National Park Authority"
    )
  end

  it "skips organisations that are not planning authorities" do
    import

    expect(Organisation.find_by(name: "Hampshire County Council")).to be_nil
  end

  it "stores references, LPA codes and end dates" do
    import

    allerdale = Organisation.find_by(reference: "local-authority:ALL")
    expect(allerdale.local_planning_authority).to eq("E60000019")
    expect(allerdale.end_date).to eq(Date.new(2023, 3, 31))
  end

  it "excludes ended authorities from the active scope" do
    import

    expect(Organisation.active.pluck(:name)).not_to include("Allerdale Borough Council")
  end

  it "updates existing records instead of duplicating them" do
    import

    renamed = local_authority_csv.sub("New Forest District Council", "New Forest Council")
    stub_dataset("local-authority", body: renamed)
    import

    expect(Organisation.count).to eq(3)
    expect(Organisation.find_by(reference: "local-authority:NEW").name).to eq("New Forest Council")
  end

  it "aborts without writing when too few organisations are found" do
    expect { import(minimum: 10) }
      .to raise_error(described_class::ImportError, /Only 3 organisations/)

    expect(Organisation.count).to eq(0)
  end

  it "aborts when the CSV format changes" do
    stub_dataset("local-authority", body: "dataset,title\nlocal-authority,Somewhere\n")

    expect { import }.to raise_error(described_class::ImportError, /missing columns/)
  end

  it "aborts without writing when a download fails" do
    stub_dataset("national-park-authority", status: 500)

    expect { import }.to raise_error(OpenURI::HTTPError)
    expect(Organisation.count).to eq(0)
  end
end
