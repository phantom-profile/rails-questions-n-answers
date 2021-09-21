# frozen_string_literal: true

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'unauth guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'auth user admin' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'auth user' do
    let(:user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }
    let(:vote) { create(:vote, user: user) }

    let(:alien_question) { create(:question, user: create(:user)) }
    let(:alien_answer) { create(:answer, user: create(:user)) }
    let(:alien_vote) { create(:vote, user: create(:user)) }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }

    it { is_expected.to be_able_to :update, question }
    it { is_expected.to be_able_to :update, answer }

    it { is_expected.to be_able_to :destroy, question }
    it { is_expected.to be_able_to :destroy, answer }
    it { is_expected.to be_able_to :destroy, vote }

    it { is_expected.not_to be_able_to :update, alien_question }
    it { is_expected.not_to be_able_to :update, alien_answer }

    it { is_expected.not_to be_able_to :destroy, alien_question }
    it { is_expected.not_to be_able_to :destroy, alien_answer }
    it { is_expected.not_to be_able_to :destroy, alien_vote }
  end
end
