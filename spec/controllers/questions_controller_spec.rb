# frozen_string_literal: true

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 5) }
    before { get :index }

    it 'gets all questions from DB' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attrs' do
      it 'saves new Question in DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attrs' do
      it 'does not save new Question in DB' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end
      it 're-renders new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attrs' do
      it 'gets one exact question from DB' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it 'saves changed Question in DB' do
        patch :update, params: { id: question, question: { title: 'changing title', body: 'changing body' } }
        question.reload

        expect(question.title).to eq 'changing title'
        expect(question.body).to eq 'changing body'
      end
      it 'redirects to show' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to :question
      end
    end
    context 'with invalid attrs' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      it 'gets one exact question from DB' do
        expect(assigns(:question)).to eq question
      end
      it 'does not save changed Question in DB' do
        title = question.title
        body = question.body
        question.reload

        expect(question.title).to eq title
        expect(question.body).to eq body
      end
      it 're-render edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    it 'deletes exact Question from DB' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end
    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
