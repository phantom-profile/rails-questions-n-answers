# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |i|
    "Title #{i}"
  end

  factory :question do
    title
    body { 'MyText' }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
