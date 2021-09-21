# frozen_string_literal: true

feature 'Author of question can choose best answer', "
  In order to show which answer is most useful
  As a auth user
  I'd like to choose best answer and do not allow to choose it by others
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given!(:question) { user_one.questions.create(title: 'title 1', body: 'body 1') }
  given!(:best_answer) { user_two.answers.create(body: 'wrong answer body', question: question) }
  given!(:wrong_answer) { user_two.answers.create(body: 'best answer body', question: question) }

  describe 'auth user', js: true do
    scenario 'tries to choose best answer' do
      sign_in user_one
      visit question_path(question)

      expect(page).to have_content 'Choose as best answer'

      click_on('Choose as best answer', match: :first)

      within '.best-answer' do
        expect(page).to have_content 'best answer body'
        expect(page).not_to have_content 'Choose as best answer'
      end

      within '.answers' do
        expect(page).not_to have_content 'best answer body'
        expect(page).to have_content 'wrong answer body'
      end
    end

    scenario 'tries to change best answer' do
      sign_in user_one
      visit question_path(question)

      expect(page).to have_content 'Choose as best answer'

      within id: "answer-#{best_answer.id}" do
        click_on('Choose as best answer')
      end
      click_on('Choose as best answer', match: :first)
      # change of answer
      click_on('Choose as best answer', match: :first)
      within '.best-answer' do
        expect(page).to have_content 'wrong answer body'
        expect(page).not_to have_content 'Choose as best answer'
      end

      within '.answers' do
        expect(page).not_to have_content 'wrong answer body'
        expect(page).to have_content 'best answer body'
      end
    end

    scenario 'tries to choose best answer on not his question' do
      sign_in user_two
      visit question_path(question)

      expect(page).to have_content 'best answer body'
      expect(page).not_to have_content 'Choose as best answer'
    end
  end

  scenario 'not auth user tries to choose best answer', js: true do
    visit question_path(question)

    expect(page).to have_content 'best answer body'
    expect(page).not_to have_content 'Choose as best answer'
  end
end
