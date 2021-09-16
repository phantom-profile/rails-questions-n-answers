# frozen_string_literal: true

feature 'User can see rating', "
  In order to see most popular resource
  As a user
  I'd like to see rating
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'auth user can see rating' do
    sign_in user
    visit questions_path

    expect(page).to have_content "Question rating\n0"
  end

  scenario 'unauth user can see rating' do
    visit questions_path

    expect(page).to have_content "Question rating\n0"
  end
end
