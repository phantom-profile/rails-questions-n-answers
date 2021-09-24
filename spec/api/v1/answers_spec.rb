describe 'API answers' do
  let(:headers) do
    { CONTENT_TYPE: 'application/json',
      ACCEPT: 'application/json' }
  end

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }
  let!(:answer) { answers.first }
  let(:answer_responce) { json['answers'].last }

  describe "GET questions/<int:id>/answers" do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    before do
      get api_path, headers: headers, params: { access_token: token.token }
    end

    it_behaves_like 'API authorizable'

    it 'returns list of answers' do
      puts json
      expect(json['answers'].size).to eq answers.size
    end

    it 'returns all public fields' do
      answer_public_fields = %w[id body created_at updated_at comments links]
      answer_public_fields.each { |attr| expect(answer_responce[attr]).to eq answer.send(attr).as_json }
    end
  end

  describe 'POST /api/v1/questions/<int:id>/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
      let(:headers) { {} }
    end

    describe 'when auth user' do
      let(:post_request) { post api_path, params: { access_token: token.token, question_id: question.id, answer: answer_params } }

      context 'valid attributes' do
        let(:answer_params) { attributes_for(:answer, question: question) }

        it 'saves new Answer in DB' do
          expect { post_request }.to change(question.answers, :count).by(1)
        end

        it 'is successful' do
          post_request
          expect(response).to be_successful
        end
      end

      context 'invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save new Answer in DB' do
          expect { post_request }.not_to change(question.answers, :count)
        end

        it 'is not successful' do
          post_request
          expect(response).not_to be_successful
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/<int:id>' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
      let(:headers) { {} }
    end

    describe 'when auth user' do
      let(:patch_request) { patch api_path, params:
        { access_token: token.token, id: answer.id, answer: answer_params } }

      context 'valid attributes' do
        let(:answer_params) { { body: 'edited body' } }

        it 'gets one exact question from DB' do
          patch_request
          expect(assigns(:answer)).to eq answer
        end

        it 'saves changed Answer in DB' do
          patch_request
          answer.reload

          expect(question.body).to eq 'edited body'
        end

        it 'is successful' do
          patch_request
          expect(response).to be_successful
        end
      end

      context 'invalid attributes' do
        let(:answer_params) { attributes_for(:question, :invalid) }

        before { patch_request }

        it 'gets one exact answer from DB' do
          expect(assigns(:answer)).to eq answer
        end

        it 'does not save changed Answer in DB' do
          body = answer.body
          answer.reload

          expect(answer.body).to eq body
        end

        it 'is not successful' do
          expect(response).not_to be_successful
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/<int:id>' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:delete_request) { delete api_path, params: { access_token: token.token, id: answer.id } }

    it 'deletes exact Answer from DB' do
      expect { delete_request }.to change(Answer, :count).by(-1)
    end

    it 'is successful' do
      delete_request
      expect(response).to be_successful
    end
  end
end
