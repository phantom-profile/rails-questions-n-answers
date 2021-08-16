# frozen_string_literal: true

feature 'User can sign in', "
  In order to ask question
  As an unauth user
  I'd like to sign in
" do
  background { visit new_user_registration_path }
  scenario 'user tries to sign up with valid data' do
    fill_in 'Email', with: 'success@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'user tries to sign up with invalid data' do
    click_button 'Sign up'

    expect(page).to have_content '2 errors prohibited this user from being saved'
  end
end
