# frozen_string_literal: true

feature 'User can sign in', "
  In order to ask question
  As an unauth user
  I'd like to sign in
" do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'registered user tries to sing in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'unregistered user tries to sing in' do
    fill_in 'Email', with: 'wrong.email@gmail.com'
    fill_in 'Password', with: '987654321'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
