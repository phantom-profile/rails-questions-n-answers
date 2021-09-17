# frozen_string_literal: true

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:resource) { create(:question, user: user) }

  describe 'POST #create' do
    let(:create_comment) { post :create, params: { comment: comment_params }, format: :js }

    context 'auth user' do
      before { login(user) }

      context 'with valid attrs' do
        let(:comment_params) { { resource_id: resource, resource: resource.class, body: 'body' } }

        it 'saves new Answer in DB' do
          expect { create_comment }.to change(resource.comments, :count).by(1)
        end
      end

      context 'with invalid attrs' do
        let(:comment_params) { { resource_id: resource, resource: resource.class, body: nil } }

        it 'does not save new Answer in DB' do
          expect { create_comment }.not_to change(resource.comments, :count)
        end
      end
    end

    context 'with not auth user' do
      let(:comment_params) { { resource_id: resource, resource: resource.class, body: 'body' } }

      it 'does not allow to post answer' do
        expect { create_comment }.not_to change(resource.comments, :count)
      end
    end
  end
end
