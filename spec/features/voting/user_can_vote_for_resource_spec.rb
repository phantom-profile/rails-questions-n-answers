# frozen_string_literal: true

feature 'User can vote', "
  In order to choose most popular resource
  As an auth user
  I'd like to vote for useful resource
" do
  given(:user) { create(:user) }

  describe 'auth user', js: true do
    background { sign_in user }

    scenario 'votes for another user resource' do
      create(:question)
      visit questions_path
      click_on 'vote for'

      expect(page).to have_content 'You successfully voted'
      expect(page).to have_content "Question rating\n1"
      expect(page).not_to have_content 'vote for'
      expect(page).not_to have_content 'vote against'
    end

    scenario 'votes for his own user resource' do
      create(:question, user: user)
      visit questions_path

      expect(page).to have_content "Question rating\n0"
      expect(page).not_to have_content 'vote for'
      expect(page).not_to have_content 'vote against'
    end
  end

  scenario 'unauth user votes for resource' do
    create(:question)
    visit questions_path

    expect(page).to have_content "Question rating\n0"
    expect(page).not_to have_content 'vote for'
    expect(page).not_to have_content 'vote against'
  end
end
