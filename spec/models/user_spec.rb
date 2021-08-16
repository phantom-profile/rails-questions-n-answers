# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_presence_of :password }

  describe 'author_of which checks if user author of resource' do
    context 'when user is author of question and answer' do
      let(:answer) { user.answers.create(attributes_for(:answer)) }
      let(:question) { user.questions.create(attributes_for(:question)) }

      it { expect(user.author_of(answer)).to eq true }
      it { expect(user.author_of(question)).to eq true }

    context 'when user is not author of question and answer' do
      let(:answer) { create(:answer) }
      let(:question) { create(:question) }

      it { expect(user.author_of(answer)).to eq false }
      it { expect(user.author_of(question)).to eq false }
    end
  end
end
