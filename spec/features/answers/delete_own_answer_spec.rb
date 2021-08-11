# frozen_string_literal: true

feature 'Only user can delete his answer', "
  In order to remove answer by myself
  As a auth user
  I'd like to delete answer and do not allow to delete it by others
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question) { user_one.questions.create(title: 'title 1', body: 'body 1') }

  describe 'Auth user' do
    background do
      sign_in user_one
		end

    scenario 'tries to delete his own answer' do
      user_one.answers.create(body: 'answer body 1', question: question)
      visit question_path(question)

      expect(page).to have_content 'answer body 1'
      expect(page).to have_content 'Delete answer'

      click_on 'Delete answer'

      expect(page).to have_content 'answer deleted successfully'
		end

    scenario 'tries to delete not his answer' do
      user_two.answers.create(body: 'answer body 2', question: question)
      visit question_path(question)

      expect(page).to have_content 'answer body 2'
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
