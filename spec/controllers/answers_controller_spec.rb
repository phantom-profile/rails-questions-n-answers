# frozen_string_literal: true

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:create_answer) { post :create, params: { question_id: question, answer: answer_params }, format: :js }

    context 'auth user' do
      before { login(user) }

      context 'with valid attrs' do
        let(:answer_params) { attributes_for(:answer) }

        it 'saves new Answer in DB' do
          expect { create_answer }.to change(question.answers, :count).by(1)
        end

        it 'redirects to show' do
          create_answer
          expect(response).to render_template :create
        end
      end

      context 'with invalid attrs' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save new Answer in DB' do
          expect { create_answer }.not_to change(question.answers, :count)
        end
      end
    end

    context 'with not auth user' do
      let(:answer_params) { attributes_for(:answer) }

      it 'does not allow to post answer' do
        expect { create_answer }.not_to change(question.answers, :count)
      end

      it 'redirects to login page' do
        create_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: user) }
    let(:update_answer) do
      patch :update, params: { id: answer, answer: answer_params }, format: :js
    end

    context 'as auth user' do
      before { login(user) }

      context 'with valid attrs' do
        let(:answer_params) { { body: 'edited answer', user: user } }

        it 'saves changed Answer in DB' do
          update_answer
          answer.reload
          expect(answer.body).to eq 'edited answer'
        end

        it 'renders update view' do
          update_answer
          expect(response).to render_template :update
        end
      end

      context 'with invalid attrs' do
        let(:answer_params) { attributes_for(:answer, :invalid, user: user) }

        it 'does not save changed Answer in DB' do
          expect { update_answer }.not_to change(answer, :body)
        end

        it 'renders update view' do
          update_answer
          expect(response).to render_template :update
        end
      end
    end

    context 'as not auth user' do
      let(:answer_params) { { body: 'edited answer' } }

      it 'does not allow to update answer' do
        expect { update_answer }.not_to change(answer, :body)
      end

      it 'redirects to login page' do
        update_answer
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when another user tries to patch' do
      let(:alien_user) { create(:user) }
      let(:answer_params) { { body: 'edited answer', user: alien_user } }

      before { login(alien_user) }

      it 'is not change exact Answer from DB' do
        expect { update_answer }.not_to change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_answer) { delete :destroy, params: { id: answer }, format: :js }
    let!(:answer) { user.answers.create(body: 'body', question: question) }

    context 'when auth answer-owner user tries to delete' do
      before { login(user) }

      it 'deletes exact Answer from user answers' do
        expect { delete_answer }.to change(user.answers, :count).by(-1)
      end

      it 'deletes exact Answer from question answers' do
        expect { delete_answer }.to change(question.answers, :count).by(-1)
      end
    end

    context 'when another user tries to delete' do
      let(:alien_user) { create(:user) }

      before { login(alien_user) }

      it 'does not delete exact Answer from DB' do
        expect { delete_answer }.not_to change(user.answers, :count)
        expect { delete_answer }.not_to change(answer.question.answers, :count)
      end
    end

    context 'when not auth user tries to delete' do
      it 'does not delete exact Answer from DB' do
        expect { delete_answer }.not_to change(Answer, :count)
      end

      it 'redirects to login page' do
        delete_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #choose_best' do
    let(:answer) { create(:answer, question: question) }
    let(:choose_best) { patch :choose_best, params: { id: answer }, format: :js }

    context 'as user tries to choose best answer to his question' do
      before { login(user) }

      it 'changes question.best_answer in DB to exact answer' do
        choose_best
        question.reload
        expect(question.best_answer).to eq answer
      end
    end

    context 'as not auth user tries to choose best answer' do
      it 'does not change question.best_answer in DB' do
        choose_best
        question.reload
        expect(question.best_answer).to be_nil
      end
    end

    context 'alien user tries to choose best answer' do
      let(:alien_user) { create(:user) }

      before { login(alien_user) }

      it 'does not change question.best_answer in DB' do
        choose_best
        question.reload
        expect(question.best_answer).to be_nil
      end
    end
  end
end
