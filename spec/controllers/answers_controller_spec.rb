# frozen_string_literal: true

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: answer }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders new view' do
      get :new, params: { id: answer, question_id: answer.question }
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:create_answer) { post :create, params: { question_id: question, answer: answer_params } }
    context 'with valid attrs' do
      let(:answer_params) { attributes_for(:answer) }
      it 'saves new Answer in DB' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show' do
        create_answer
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attrs' do
      let(:answer_params) { attributes_for(:answer, :invalid) }
      it 'does not save new Answer in DB' do
        expect { create_answer }.to_not change(question.answers, :count)
      end

      it 're-renders new' do
        create_answer
        expect(response).to render_template :new
      end
    end
  end
end
