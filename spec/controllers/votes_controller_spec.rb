# frozen_string_literal: true

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:create_vote) { post :create, params: vote_params, format: :json }

    context 'auth user' do
      context 'with valid attrs' do
        let(:vote_params) do
          { resource: question.class,
            resource_id: question,
            user: user,
            vote_for: true }
        end

        it 'saves new vote in DB' do
          login(user)
          expect { create_vote }.to change(question.votes, :count).by(1)
        end
      end

      context 'with invalid attrs' do
        let(:vote_params) do
          { resource: question.class,
            resource_id: question,
            user: question.user,
            vote_for: true }
        end

        it 'does not save new vote in DB' do
          login(question.user)
          expect { create_vote }.not_to change(question.votes, :count)
        end
      end
    end

    context 'with not auth user' do
      let(:vote_params) { attributes_for(:vote) }

      it 'does not allow to vote' do
        expect { create_vote }.not_to change(question.votes, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:vote) { create(:vote, user: user, votable: question) }
    let(:delete_vote) { delete :destroy, params: { id: vote }, format: :json }

    context 'when auth vote-owner user tries to delete' do
      before { login(user) }

      it 'deletes exact vote from user votes' do
        expect { delete_vote }.to change(user.votes, :count).by(-1)
      end

      it 'deletes exact vote from resource votes' do
        expect { delete_vote }.to change(question.votes, :count).by(-1)
      end
    end

    context 'when another user tries to delete' do
      let(:alien_user) { create(:user) }

      before { login(alien_user) }

      it 'does not delete exact vote from DB' do
        expect { delete_vote }.not_to change(user.votes, :count)
        expect { delete_vote }.not_to change(vote.votable.votes, :count)
      end
    end

    context 'when not auth user tries to delete' do
      it 'does not delete exact vote from DB' do
        expect { delete_vote }.not_to change(Vote, :count)
      end
    end
  end
end
