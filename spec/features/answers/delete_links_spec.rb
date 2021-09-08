# frozen_string_literal: true

feature 'Only user can delete links of his answer', "
  In order to remove link in answer by myself
  As a auth user
  I'd like to delete link in answer and do not allow to delete it by others
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question) { user_one.questions.create(title: 'title 1', body: 'body 1') }
  given(:files) { [blob_for('test_1.txt').signed_id] }

  describe 'auth user', js: true do
    background do
      sign_in user_one
    end

    scenario 'tries to delete file in his own answer' do
      user_one.answers.create(body: 'answer body 1', question: question, files: files)
      visit question_path(question)

      expect(page).to have_link 'test_1.txt'
      expect(page).to have_link 'Remove'

      click_on 'Remove'
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_link 'test_1.txt'
    end

    scenario 'tries to delete file in not his answer' do
      user_two.answers.create(body: 'answer body 2', question: question, files: files)
      visit question_path(question)

      expect(page).to have_link 'test_1.txt'
      expect(page).not_to have_link 'Remove'
    end
  end

  scenario 'not auth user tries to delete file', js: true do
    user_one.answers.create(body: 'answer body 1', question: question, files: files)
    visit question_path(question)

    expect(page).to have_link 'test_1.txt'
    expect(page).not_to have_link 'Remove'
  end
end

