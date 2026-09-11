# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timetable, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:timetable_events).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:status) }

    context "when in draft state" do
      subject { build(:timetable, status: :draft) }

      it { is_expected.not_to validate_presence_of(:name) }
      it { is_expected.not_to validate_presence_of(:local_planning_authorities) }
      it { is_expected.not_to validate_presence_of(:dataset) }
      it { is_expected.not_to validate_presence_of(:description) }
      it { is_expected.not_to validate_presence_of(:period_start_date) }
      it { is_expected.not_to validate_presence_of(:period_end_date) }
      it { is_expected.not_to validate_presence_of(:documentation_url) }
      it { is_expected.not_to validate_presence_of(:document_url) }
      it { is_expected.not_to validate_presence_of(:entry_date) }
      it { is_expected.not_to validate_presence_of(:required_housing) }
      it { is_expected.not_to validate_presence_of(:reference) }
    end

    context "when in published state" do
      subject { build(:timetable, status: :published) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:local_planning_authorities) }
      it { is_expected.to validate_presence_of(:dataset) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:period_start_date) }
      it { is_expected.to validate_presence_of(:period_end_date) }
      it { is_expected.to validate_presence_of(:documentation_url) }
      it { is_expected.to validate_presence_of(:document_url) }
      it { is_expected.to validate_presence_of(:entry_date) }
      it { is_expected.to validate_presence_of(:required_housing) }
      it { is_expected.to validate_presence_of(:reference) }
    end
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:status)
        .with_values(draft: "draft", published: "published")
        .backed_by_column_of_type(:string)
    }
  end
end
