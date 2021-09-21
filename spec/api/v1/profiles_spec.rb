describe 'Profiles API' do
  let(:headers) do
    { CONTENT_TYPE: 'application/json',
      ACCEPT: 'application/json' }
  end

  describe 'GET profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when auth user' do
      let(:me) { create(:user) }
      let(:token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, headers: headers, params: { access_token: token.token }
      end

      it_behaves_like 'readable profiles' do
        let(:checked_user) { json }
        let(:user_object) { me }
      end
    end
  end

  describe 'GET profiles/' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when auth user' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, headers: headers, params: { access_token: token.token }
      end

      it 'returns 200 status' do
        puts response.status
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json.size).to eq users.size
      end

      it_behaves_like 'readable profiles' do
        let(:checked_user) { json.first }
        let(:user_object) { users.first }
      end
    end
  end
end
