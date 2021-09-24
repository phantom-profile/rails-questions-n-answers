# frozen_string_literal: true

RSpec.describe Question, type: :model do
  it_behaves_like 'attachable'

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to belong_to(:best_answer).without_validating_presence }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it 'shows only one day fresh questions' do
    create(:question, created_at: 2.days.ago)
    new_question = create(:question)

    expect(described_class.less_then_one_day_ago.count).to eq 1
    expect(described_class.less_then_one_day_ago.first).to eq new_question
  end
end
