# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject(:vote) { create(:vote) }

  it { is_expected.to belong_to(:votable) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :votable }
  it { is_expected.to validate_presence_of :user }
  it { expect(vote).to validate_inclusion_of(:voted_for).in_array([true, false]) }

  it 'is sorted for or against' do
    answer = create(:answer)
    answer.votes = create_list(:vote, 3) + create_list(:vote, 2, :against)

    expect(answer.votes.for(answer).count).to eq 3
    expect(answer.votes.against(answer).count).to eq 2
  end

  it 'validates that user is not author of resource' do
    user = create(:user)
    resource = create(:question, user: user)
    vote = described_class.new(user: user, votable: resource, voted_for: true)

    expect(vote).to be_invalid
  end
end
