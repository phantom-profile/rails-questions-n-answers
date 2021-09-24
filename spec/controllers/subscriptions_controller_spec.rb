# frozen_string_literal: true

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:create_subscription) { post :create, params: subscription_params }

    context 'auth user' do
      context 'with valid attrs' do
        let(:subscription_params) do
          { resource: question.class,
            resource_id: question,
            user: user }
        end

        it 'saves new subscription in DB' do
          login(user)
          expect { create_subscription }.to change(question.subscriptions, :count).by(1)
        end
      end
    end

    context 'with not auth user' do
      let(:subscription_params) { attributes_for(:subscription) }

      it 'does not allow to subscribe' do
        expect { create_subscription }.not_to change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, subscriptable: question) }
    let(:delete_subscription) { delete :destroy, params: { id: subscription } }

    context 'when auth subscription-owner user tries to delete' do
      before { login(user) }

      it 'deletes exact subscription from user subscriptions' do
        expect { delete_subscription }.to change(user.subscriptions, :count).by(-1)
      end

      it 'deletes exact subscription from resource subscriptions' do
        expect { delete_subscription }.to change(question.subscribers, :count).by(-1)
      end
    end

    context 'when another user tries to delete' do
      let(:alien_user) { create(:user) }

      before { login(alien_user) }

      it 'does not delete exact subscription from DB' do
        expect { delete_subscription }.not_to change(user.subscriptions, :count)
        expect { delete_subscription }.not_to change(subscription.subscriptable.subscriptions, :count)
      end
    end

    context 'when not auth user tries to delete' do
      it 'does not delete exact subscription from DB' do
        expect { delete_subscription }.not_to change(Subscription, :count)
      end
    end
  end
end

