# frozen_string_literal: true

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to belong_to(:best_answer).without_validating_presence }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(described_class.new.files).to be_instance_of ActiveStorage::Attached::Many
  end
end
