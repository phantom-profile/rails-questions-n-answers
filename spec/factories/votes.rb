FactoryBot.define do
  factory :vote do
    votable { create(:answer) }
    user
    voted_for { true }

    trait :against do
      votable { create(:answer) }
      user
      voted_for { false }
    end
  end
end
