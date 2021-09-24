# frozen_string_literal: true

feature 'User can subscribe', "
  In order to know about fresh answers
  As an auth user
  I'd like to subscribe on useful resource
" do
  given(:user) { create(:user) }

  describe 'auth user' do
    background { sign_in user }

    scenario 'subscribe for resource' do
      create(:question)
      visit questions_path
      click_on 'receive update news'

      expect(page).to have_content 'successfully subscribed'
      expect(page).not_to have_content 'receive update news'
    end
  end

  scenario 'unauth user subscribe for resource' do
    create(:question)
    visit questions_path

    expect(page).not_to have_content 'receive update news'
  end
end

