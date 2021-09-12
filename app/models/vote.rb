class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :answer

  validates_presence_of :answer, :user
  validates_inclusion_of :voted_for, in: [true, false]

  scope :for, ->(answer) { where(answer: answer, voted_for: true) }
  scope :against, ->(answer) { where(answer: answer, voted_for: false) }
end
