# frozen_string_literal: true

feature 'User can vote', "
  In order to choose most popular resource
  As an auth user
  I'd like to vote for useful resource
" do
  given(:user) { create(:user) }

  scenario 'auth user can remove his vote', js: true do
    question = create(:question)
    create(:vote, user: user, votable: question, voted_for: true)

    sign_in user
    visit questions_path

    expect(page).to have_content "Question rating\n1"

    click_on 'remove vote'

    expect(page).to have_content 'You unvoted'
    expect(page).to have_content "Question rating\n0"
    expect(page).not_to have_content 'remove vote'
  end
end
