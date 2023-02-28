# frozen_string_literal: true

FactoryBot.define do
  factory :employee, class: 'Employee' do
    full_name { Faker::Name.unique.name }
    sequence(:email, 1) { |n| "employee#{n}@dopay.com" }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.unique.phone_number }
  end
end
