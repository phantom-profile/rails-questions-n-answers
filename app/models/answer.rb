# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many_attached :files
  has_many :links, as: :linkable, dependent: :destroy

  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank
  validates :body, :question, presence: true

  default_scope -> { order(created_at: :desc) }
  scope :without_best, ->(answer) { where.not(id: answer) }
end
