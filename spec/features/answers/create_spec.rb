# frozen_string_literal: true

feature 'User can answer question', "
  In order to help another user
  As an auth user
  I'd like to answer question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'auth user', js: true do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'answer with valid data' do
      fill_in 'Body', with: 'test answer'

      click_on 'Answer now'

      expect(page).to have_content 'test answer'
    end

    scenario 'answer with attached files' do
      fill_in 'Body', with: 'answer body'
      attach_file 'Files', ["#{Rails.root}/spec/fixtures/files/test_1.txt",
                            "#{Rails.root}/spec/fixtures/files/test_2.txt"]
      click_on 'Answer now'

      expect(page).to have_link 'test_1.txt'
      expect(page).to have_link 'test_2.txt'
    end

    scenario 'answer with invalid data' do
      click_on 'Answer now'

      expect(page).not_to have_content 'Delete answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiple sessions', js: true do
    scenario 'user create question and everybody sees it' do
      Capybara.using_session('user1') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('user2') do
        visit question_path(question)
      end

      Capybara.using_session('user1') do
        fill_in 'Body', with: 'test answer'
        click_on 'Answer now'

        expect(page).to have_content 'test answer'
      end

      Capybara.using_session('user1') do
        expect(page).to have_content 'test answer'
      end
    end
  end

  scenario 'not auth user tries to answer' do
    visit question_path(question)
    click_on 'Answer now'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
