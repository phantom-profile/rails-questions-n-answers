# frozen_string_literal: true

# используй rubocop-rspec
# проверено. Рубокоп ругается только на высокую вложенность но тут из-за проверок
# для залогиненного и нет пользователя так происходит
RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    # можно силно улучшить читаемость кода объявив запрос в let сразу после describe
    # сделано
    let(:create_answer) { post :create, params: { question_id: question, answer: answer_params } }

    context 'Auth user' do
      before { login(user) }

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
          expect { create_answer }.not_to change(question.answers, :count)
        end
      end
    end

    # не хватает сценарий дла неаутентифицированного юзера
    # исправлено
    context 'Not auth user' do
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

  describe 'DELETE #destroy' do
    let(:delete_answer) { delete :destroy, params: { id: answer } }
    let!(:answer) { user.answers.create(body: 'body', question: question) }

    context 'when auth answer-owner user tries to delete' do
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

    context 'when another user tries to delete' do
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

    context 'when not auth user tries to delete' do
      it 'is not delete exact Answer from DB' do
        expect { delete_answer }.to change(Answer, :count).by(0)
      end

      it 'redirects to login page' do
        delete_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
