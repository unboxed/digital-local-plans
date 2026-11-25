# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organisation

  def organisation_attributes=(attributes)
    self.organisation = Organisation.find_or_initialize_by_name(attributes[:name])
  end

    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end
