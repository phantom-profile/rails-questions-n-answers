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
      attach_file 'Files', ["#{Rails.root}/spec/fixtures/files/test_1.txt",
                            "#{Rails.root}/spec/fixtures/files/test_2.txt"]
      click_on 'Ask'

      expect(page).to have_link 'test_1.txt'
      expect(page).to have_link 'test_2.txt'
    end

    scenario 'asks question with attached reward' do
      fill_in 'Title', with: 'test question'
      fill_in 'Body', with: 'question body'
      fill_in 'Reward title', with: 'test reward'
      attach_file 'Image', "#{Rails.root}/spec/fixtures/files/image.jpeg"
      click_on 'Ask'

      expect(page).to have_content 'There is a reward for best question'
      expect(page).to have_content 'test reward'
    end

    scenario 'asks question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'multiple sessions', js: true do
    scenario 'user create question and everybody sees it' do
      Capybara.using_session('user1') do
        sign_in(user)
        visit new_question_path
      end

      Capybara.using_session('user2') do
        visit questions_path
      end

      Capybara.using_session('user1') do
        fill_in 'Title', with: 'test question'
        fill_in 'Body', with: 'question body'
        click_on 'Ask'

        expect(page).to have_content 'test question'
      end

      Capybara.using_session('user2') do
        expect(page).to have_content 'test question'
      end
    end
  end

  scenario 'not auth user tries to ask question' do
    visit questions_path

    expect(page).not_to have_link 'Ask question'
  end
end
