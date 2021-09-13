# frozen_string_literal: true

RSpec.describe RewardsController, type: :controller do
  let(:rewards) { create_list(:reward, 5) }
  let(:user) { create(:user, rewards: rewards) }

  describe 'GET #index' do
    before do
      login(user)
      get :index
    end

    it 'gets all current user rewards from DB' do
      expect(assigns(:rewards)).to match_array rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
