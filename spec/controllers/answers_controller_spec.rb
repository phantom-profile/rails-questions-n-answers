# frozen_string_literal: true

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { create(:answer) }
    it 'renders show view' do
      get :show, params: { id: answer }
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }
    let(:create_answer) { post :create, params: { question_id: question, answer: answer_params } }

    context 'with valid attrs' do
      let(:answer_params) { attributes_for(:answer) }
      it 'saves new Answer in DB' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show' do
        create_answer
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'with invalid attrs' do
      let(:answer_params) { attributes_for(:answer, :invalid) }
      it 'does not save new Answer in DB' do
        expect { create_answer }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_answer) { delete :destroy, params: { id: answer } }
    let!(:answer) { user.answers.create(body: 'body', question: question) }

    context 'logged in user' do
      before { login(user) }
      it 'deletes exact Answer from user answers' do
        expect { delete_answer }.to change(user.answers, :count).by(-1)
			end

      it 'deletes exact Answer from question answers' do
        expect { delete_answer }.to change(question.answers, :count).by(-1)
			end

      it 'redirects to question' do
        delete_answer
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'another user' do
      let(:alien_user) { create(:user) }
      before { login(alien_user) }

      it 'is not delete exact Answer from DB' do
        expect { delete_answer }.to change(user.answers, :count).by(0)
        expect { delete_answer }.to change(answer.question.answers, :count).by(0)
			end

      it 'redirects to question' do
        delete_answer
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
