# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question, presence: true
  default_scope -> { order(created_at: :desc) }
end
