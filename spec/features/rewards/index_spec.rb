# frozen_string_literal: true

feature 'User can look at question list', "
  In order to solve different problems described on site
  As a user
  I'd like to look at question list
" do
  given!(:rewards) { create_list(:reward, 5) }
  given(:user) { create(:user, rewards: rewards) }

  scenario 'auth user sees full list of his rewards' do
    sign_in user
    visit rewards_path

    expect(page).to have_content rewards[0].title
    expect(page).to have_content rewards[4].title

    expect(page).to have_content rewards[0].question.title
    expect(page).to have_content rewards[4].question.title
  end
end
