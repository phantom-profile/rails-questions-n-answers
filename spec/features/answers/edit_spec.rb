# frozen_string_literal: true

feature 'User can edit his own answer', "
  In order to correct mistakes in answer
  As an author of answer
  I'd like to edit my answer
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given!(:question) { user_one.questions.create(title: 'title 1', body: 'body 1') }

  scenario 'not auth user cannot edit answers' do
    user_one.answers.create(body: 'answer body 1', question: question)
    visit question_path(question)

    expect(page).to have_content 'answer body 1'
    expect(page).not_to have_content 'Edit answer'
  end

  describe 'auth user' do
    background do
      sign_in user_one
    end

    context 'is owner of answer', js: true do
      background do
        user_one.answers.create(body: 'answer body 1', question: question)
        visit question_path(question)
      end

      scenario 'edit answer correctly' do
        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Body', with: 'edited test answer'
          click_on 'Save'

          expect(page).not_to have_selector 'textarea'
        end

        expect(page).not_to have_content 'answer body 1'
        expect(page).to have_content 'edited test answer'
      end

      scenario 'edit answer with attached files' do
        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Body', with: 'edited test answer'
          attach_file 'Files', ["#{Rails.root}/test_files/test_1.txt", "#{Rails.root}/Gtest_files/test_2.txt"]
          click_on 'Save'

          expect(page).not_to have_selector 'textarea'
        end

        expect(page).to have_link 'README.md'
        expect(page).to have_link 'Gemfile.lock'
      end

      scenario 'edit answer not correctly' do
        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Body', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'is not owner and cannot edit answer' do
      user_two.answers.create(body: 'answer body 1', question: question)

      visit question_path(question)

      expect(page).to have_content 'answer body 1'
      expect(page).not_to have_content 'Edit answer'
    end
  end
end
