# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  include IsVotable

  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, as: :linkable, dependent: :destroy

  validates :body, :question, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blan
  scope :without_best, ->(answer) { where.not(id: answer) }
end
