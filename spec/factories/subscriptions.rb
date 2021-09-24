# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    subscriptable { create(:question) }
    user
  end
end
