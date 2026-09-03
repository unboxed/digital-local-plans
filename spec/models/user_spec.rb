# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:organisation) }
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "default organisation" do
    it "defaults to the 'Unboxed' organisation on initialization" do
      user = build(:user)
      expect(user.organisation).to be_present
      expect(user.organisation.name).to eq("Unboxed")
      expect(user.organisation.email).to eq("dlp@unboxed.co")
    end

    it "allows overriding with a custom organisation" do
      specific_lpa = build(:organisation, name: "Specific LPA")
      user = build(:user, organisation: specific_lpa)

      expect(user.organisation).to eq(specific_lpa)
    end
  end
end
