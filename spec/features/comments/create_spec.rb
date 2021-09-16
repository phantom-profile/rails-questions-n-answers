# frozen_string_literal: true

feature 'User can comment resource', "
  In order to react another user post
  As an auth user
  I'd like to comment resources
" do
  given(:user) { create(:user) }
  given!(:resource) { create(:question) }

  describe 'auth user', js: true do
    background do
      sign_in user

      visit questions_path
    end

    scenario 'comment with valid data' do
      fill_in 'Comment body', with: 'test comment'

      click_on 'Comment'

      expect(page).to have_content 'test comment'
    end

    scenario 'Comment with invalid data' do
      click_on 'Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiple sessions', js: true do
    scenario 'user create comment and everybody sees it' do
      Capybara.using_session('user1') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('user2') do
        visit questions_path
      end

      Capybara.using_session('user1') do
        fill_in 'Comment body', with: 'test comment'
        click_on 'Comment'

        expect(page).to have_content 'test comment'
      end

      Capybara.using_session('user1') do
        expect(page).to have_content 'test comment'
      end
    end
  end

  scenario 'not auth user tries to comment' do
    visit questions_path

    expect(page).not_to have_content 'Comment body'
  end
end

