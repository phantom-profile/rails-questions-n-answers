# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many_attached :files

  belongs_to :question
  belongs_to :user

  validates :body, :question, presence: true

  default_scope -> { order(created_at: :desc) }
  scope :without_best, ->(answer) { where.not(id: answer) }
end
