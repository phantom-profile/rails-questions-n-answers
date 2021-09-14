RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:resource) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    let(:destroy) { delete :destroy, params: { id: resource.links.first } }

    before { create(:link, linkable: resource) }

    context 'as user tries to delete link in his resource' do
      before { login(user) }

      it 'deletes link from db' do
        expect { destroy }.to change(resource.links, :count).by(-1)
      end
    end

    context 'as user tries to delete link not in his question' do
      let(:alien_user) { create(:user) }

      before { login(alien_user) }

      it 'does not delete file from db' do
        expect { destroy }.not_to change(resource.links, :count)
      end
    end

    context 'as not auth user tries to delete link' do
      it 'does not delete file from db' do
        expect { destroy }.not_to change(resource.links, :count)
      end
    end
  end
end
