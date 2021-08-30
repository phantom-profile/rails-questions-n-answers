# frozen_string_literal: true

feature 'User can look at question list', "
  In order to solve different problems described on site
  As a user
  I'd like to look at question list
" do
  given!(:questions) { create_list(:question, 5) }
  given(:user) { create(:user) }

  scenario 'not auth user sees full list of questions' do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[4].title
  end

  scenario 'auth user sees full list of questions' do
    sign_in user
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[4].title
  end
end
