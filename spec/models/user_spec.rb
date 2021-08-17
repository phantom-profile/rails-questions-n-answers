# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_presence_of :password }

  describe 'author_of which checks if user author of resource' do
    context 'when user is author of question and answer' do
      let(:question) { user.questions.create(attributes_for(:question)) }

      it { expect(user).to be_author_of(question) }
    end

    context 'when user is not author of question and answer' do
      let(:question) { create(:question) }

      it { expect(user).not_to be_author_of(question) }
    end
  end
end
