# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organisation

  validates :organisation_id, presence: {message: "Select your organisation"}
  validates :organisation, presence: true, if: :organisation_id?

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end
