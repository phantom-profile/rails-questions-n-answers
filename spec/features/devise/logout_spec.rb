# frozen_string_literal: true

feature 'User can logout', "
  In order to end session
  As an auth user
  I'd like to logout
" do
  given(:user) { User.create(email: 'email@gmail.com', password: '123456789') }
  background do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  scenario 'registered user tries to logout' do
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
