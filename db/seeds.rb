# frozen_string_literal: true

require 'timecop'

Rails.logger.debug 'Inserting records into Employee table'
time = 100.days.ago
5_000_000.times do |i|
  Rails.logger.debug { "Current Index: #{i}" } if (i % 10_000).zero?
  Timecop.freeze(time + i.minutes.to_s) do
    emp = FactoryBot.build :employee
    emp.save!
  end
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.debug { "Error while adding employee record: #{e.message}" }
  next
end
