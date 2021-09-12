FactoryBot.define do
  factory :vote do
    answer
    user
    voted_for { true }

    trait :against do
      answer
      user
      voted_for { false }
    end
  end
end
