# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
end
