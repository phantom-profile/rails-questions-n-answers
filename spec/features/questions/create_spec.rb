# frozen_string_literal: true

feature 'User can ask question', "
  In order to get answers for question
  As an auth user
  I'd like to ask question
" do
  given(:user) { create(:user) }

  describe 'auth user' do
    background do
      sign_in user

      visit questions_path
      click_on 'Ask question'
    end
    scenario 'asks question' do
      fill_in 'Title', with: 'test question'
      fill_in 'Body', with: 'question body'
      click_on 'Ask'

      expect(page).to have_content 'Question created successfully'
      expect(page).to have_content 'test question'
    end

    scenario 'asks question with attached files' do
      fill_in 'Title', with: 'test question'
      fill_in 'Body', with: 'question body'
      attach_file 'Files', ["#{Rails.root}/test_files/test_1.txt", "#{Rails.root}/Gtest_files/test_2.txt"]
      click_on 'Ask'

      expect(page).to have_link 'README.md'
      expect(page).to have_link 'Gemfile.lock'
    end

    scenario 'asks question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'not auth user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
