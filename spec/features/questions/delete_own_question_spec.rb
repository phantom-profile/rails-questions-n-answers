# frozen_string_literal: true

feature 'Only user can delete his question', "
  In order to remove question by myself
  As a auth user
  I'd like to delete question and do not allow to delete it by others
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }

  describe 'Auth user' do
    background do
      sign_in user_one
    end

    scenario 'tries to delete his own question' do
      question = user_one.questions.create(title: 'title 1', body: 'body 1')
      visit question_path(question)

      expect(page).to have_content 'Delete'

      click_on 'Delete'

      expect(page).to have_content 'question deleted successfully'
      expect(page).not_to have_content 'body 1'
    end

    scenario 'tries to delete not his answer' do
      question = user_two.questions.create(title: 'title 2', body: 'body 2')
      visit question_path(question)

      expect(page).to have_content 'body 2'
      expect(page).not_to have_content 'Delete'
    end
  end
end
