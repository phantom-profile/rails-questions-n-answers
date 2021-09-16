# frozen_string_literal: true

feature 'User cannot vote twice', "
  In order to have fair voting
  As an auth user
  I'd like to vote only once
" do
  given(:user) { create(:user) }

  scenario 'votes for another user resource and disabled to repeat voting', js: true do
    create(:question)

    sign_in user
    visit questions_path
    click_on 'vote for'

    expect(page).to have_content 'You successfully voted'
    expect(page).not_to have_content 'vote for'
    expect(page).not_to have_content 'vote against'
  end
end
