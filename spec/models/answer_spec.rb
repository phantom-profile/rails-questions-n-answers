# frozen_string_literal: true

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :question }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(described_class.new.files).to be_instance_of ActiveStorage::Attached::Many
  end
end
