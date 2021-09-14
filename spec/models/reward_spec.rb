require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :image }

  it 'has one attached image' do
    expect(described_class.new.image).to be_instance_of ActiveStorage::Attached::One
  end

  it 'has image only' do
    expect(described_class.new(attributes_for(:reward))).to be_valid
    expect(described_class.new(attributes_for(:reward, :invalid))).to be_invalid
  end
end
