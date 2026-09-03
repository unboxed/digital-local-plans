# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}
end
