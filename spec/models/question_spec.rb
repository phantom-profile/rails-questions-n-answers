# frozen_string_literal: true

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to belong_to(:best_answer).without_validating_presence }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
end
