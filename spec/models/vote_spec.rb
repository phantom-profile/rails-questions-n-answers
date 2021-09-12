require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject(:vote) { described_class.create(attributes_for(:vote)) }

  it { should belong_to(:answer) }
  it { should belong_to(:user) }

  it { should validate_presence_of :answer }
  it { should validate_presence_of :user }
  it { expect(vote).to validate_inclusion_of(:voted_for).in_array([true, false]) }

  it 'should be sorted for or against' do
    answer = create(:answer)
    answer.votes = create_list(:vote, 3) + create_list(:vote, 2, :against)

    expect(answer.votes.for(answer).count).to eq 3
    expect(answer.votes.against(answer).count).to eq 2
  end
end
