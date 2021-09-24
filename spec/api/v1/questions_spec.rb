describe 'Questions API' do
  let(:headers) do
    { CONTENT_TYPE: 'application/json',
      ACCEPT: 'application/json' }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when auth user' do
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_responce) { json['questions'].first }

      before do
        get api_path, headers: headers, params: { access_token: token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        question_public_fields = %w[id title body
                                    created_at updated_at best_answer]
        question_public_fields.each { |attr| expect(question_responce[attr]).to eq question.send(attr).as_json }
      end

      it 'has user object' do
        expect(question_responce['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'GET /api/v1/questions/<int:id>' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_responce) { json['question'] }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'when auth user' do
      before do
        get api_path, headers: headers, params: { access_token: token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        question_public_fields = %w[id title body
                                    created_at updated_at
                                    best_answer user comments answers links]
        question_public_fields.each { |attr| expect(question_responce[attr]).to eq question.send(attr).as_json }
      end

      it 'has user object' do
        expect(question_responce['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
      let(:headers) { {} }
    end

    describe 'when auth user' do
      let(:post_request) { post api_path, params: { access_token: token.token, question: question_params } }

      context 'valid attributes' do
        let(:question_params) { attributes_for(:question) }

        it 'saves new Question in DB' do
          expect { post_request }.to change(Question, :count).by(1)
        end

        it 'is successful' do
          post_request
          expect(response).to be_successful
        end
      end

      context 'invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not save new Question in DB' do
          expect { post_request }.not_to change(Question, :count)
        end

        it 'is not successful' do
          post_request
          expect(response).not_to be_successful
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/<int:id>' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_responce) { json['question'] }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
      let(:headers) { {} }
    end

    describe 'when auth user' do
      let(:patch_request) do
        patch api_path, params:
        { access_token: token.token, id: question.id, question: question_params }
      end

      context 'valid attributes' do
        let(:question_params) { { body: 'edited body' } }

        it 'gets one exact question from DB' do
          patch_request
          expect(assigns(:question)).to eq question
        end

        it 'saves changed Question in DB' do
          patch_request
          question.reload

          expect(question.body).to eq 'edited body'
        end

        it 'is successful' do
          patch_request
          expect(response).to be_successful
        end
      end

      context 'invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        before { patch_request }

        it 'gets one exact question from DB' do
          expect(assigns(:question)).to eq question
        end

        it 'does not save changed Question in DB' do
          body = question.body
          question.reload

          expect(question.body).to eq body
        end

        it 'is not successful' do
          expect(response).not_to be_successful
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/<int:id>' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:delete_request) { delete api_path, params: { access_token: token.token, id: question.id } }

    it 'deletes exact Question from DB' do
      expect { delete_request }.to change(Question, :count).by(-1)
    end

    it 'is successful' do
      delete_request
      expect(response).to be_successful
    end
  end
end
