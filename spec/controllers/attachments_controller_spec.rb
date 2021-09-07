# frozen_string_literal: true

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:files) { [blob_for('test_1.txt').signed_id] }
  let(:resource) { create(:question, files: files, user: user) }

  describe 'DELETE #destroy' do
    let(:destroy) { delete :destroy, params: { id: resource.files.first } }

    context 'as user tries to delete file in his resource' do
      before { login(user) }

      it 'deletes file from db' do
        expect { destroy }.to change(resource.files, :count).by(-1)
      end
    end

    context 'as user tries to delete file not in his question' do
      let(:alien_user) { create(:user) }

      before { login(alien_user) }

      it 'does not delete file from db' do
        expect { destroy }.not_to change(resource.files, :count)
      end
    end

    context 'as not auth user tries to delete file' do
      it 'does not delete file from db' do
        expect { destroy }.not_to change(resource.files, :count)
      end
    end
  end
end
