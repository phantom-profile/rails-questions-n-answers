# frozen_string_literal: true

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:best_answer).without_validating_presence }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links}

  it 'has many attached files' do
    expect(described_class.new.files).to be_instance_of ActiveStorage::Attached::Many
  end
end
