# frozen_string_literal: true

RSpec.describe User, type: :model do

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_presence_of :password }

  describe '#author_of? which checks if user created resource' do
    subject(:user) { create(:user) }

    context 'when user is author of resource' do
      let(:question) { user.questions.create(attributes_for(:question)) }

      it { is_expected.to be_author_of(question) }
    end

    context 'when user is not author of resource' do
      let(:question) { create(:question) }

      it { is_expected.not_to be_author_of(question) }
    end
  end
end
