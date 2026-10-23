# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organisation
  accepts_nested_attributes_for :organisation

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end
