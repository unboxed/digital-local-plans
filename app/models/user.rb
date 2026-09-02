# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organisation

  validates :email, presence: {case_sensitive: false}

  attribute :organisation_id, default: -> {
    Organisation.find_or_create_by!(name: "Unboxed", email: "dlp@unboxed.co").id
  }

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end
