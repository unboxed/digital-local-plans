# frozen_string_literal: true

require "rails_helper"

RSpec.describe Organisation, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:users) }
  end

  describe "validations" do
    subject { build(:organisation) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:organisation)).to be_valid
    end
  end

  describe "#current_timetable" do
    let(:organisation) { create(:organisation) }

    let!(:previous_timetable) { create(:timetable, organisation:, period_end_date: 2.years.ago) }
    let!(:near_future_timetable) { create(:timetable, organisation:, period_end_date: 5.years.from_now) }
    let!(:distant_future_timetable) { create(:timetable, organisation:, period_end_date: 10.years.from_now) }

    subject(:current_timetable) { organisation.current_timetable }

    # it "returns the nearest timetable whose period_end_date is in the future" do
    #   expect(current_timetable).to eq(near_future_timetable)
    # end

    it "ignores timetables from the past" do
      expect(current_timetable).not_to eq(previous_timetable)
    end

    # context "when no future timetables exist" do
    #   let!(:near_future_timetable) { nil }
    #   let!(:distant_future_timetable) { nil }

    #   it "returns nil" do
    #     expect(current_timetable).to be_nil
    #   end
    # end
  end
end
