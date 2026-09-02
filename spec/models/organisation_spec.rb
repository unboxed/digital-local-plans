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
end
