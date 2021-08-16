# frozen_string_literal: true

feature 'User can answer question', "
  In order to help another user
  As an auth user
  I'd like to answer question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Auth user' do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'answer with valid data' do
      fill_in 'Body', with: 'test answer'

      click_on 'Answer now'

      expect(page).to have_content 'Answer created successfully'
      expect(page).to have_content 'test answer'
    end

    scenario 'answer with invalid data' do
      click_on 'Answer now'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'not auth user tries to answer' do
    visit question_path(question)
    click_on 'Answer now'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
