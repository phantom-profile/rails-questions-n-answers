# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |i|
    "user#{i}@test.com"
  end

  factory :user do
    email
    password { '123456789' }
    password_confirmation { '123456789' }
  end
end
