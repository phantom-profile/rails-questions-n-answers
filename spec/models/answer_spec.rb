# frozen_string_literal: true

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question }

  it { should accept_nested_attributes_for :links}

  it 'has many attached files' do
    expect(described_class.new.files).to be_instance_of ActiveStorage::Attached::Many
  end
end
