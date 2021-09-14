# frozen_string_literal: true

feature 'User can add link to question', "
  In order to have detailed info in question
  As an auth user
  I'd like to add link to resource in question
" do
  given(:user) { create(:user) }
  given(:link) { 'https://vk.com/' }

  describe 'auth user creating question', js: true do
    background do
      sign_in user

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'adds link to question' do
      fill_in 'Title', with: 'test title'
      fill_in 'Body', with: 'test question'
      fill_in 'Link name', with: 'vk page'
      fill_in 'Url', with: link

      click_on 'Ask'

      expect(page).to have_content 'test question'
      expect(page).to have_link 'vk page', href: link
    end

    scenario 'adds many links to question' do
      fill_in 'Title', with: 'test title'
      fill_in 'Body', with: 'test question'
      fill_in 'Link name', with: 'vk page 1'
      fill_in 'Url', with: link

      click_on 'add link'

      within page.all('.nested-fields')[1] do
        fill_in 'Link name', with: 'vk page 2'
        fill_in 'Url', with: link, match: :prefer_exact
      end

      click_on 'Ask'

      expect(page).to have_content 'test question'
      expect(page).to have_link 'vk page 1', href: link
      expect(page).to have_link 'vk page 2', href: link
    end
  end

  describe 'auth user editing question', js: true do
    background do
      user.questions.create(title: 'test question', body: 'test body')

      sign_in user

      visit questions_path
      click_on 'Edit question'
      click_on 'add link'
    end

    scenario 'adds link to question' do
      fill_in 'Link name', with: 'vk page'
      fill_in 'Url', with: link

      click_on 'Ask'

      expect(page).to have_content 'test question'
      expect(page).to have_link 'vk page', href: link
    end

    scenario 'adds many links to question' do
      fill_in 'Link name', with: 'vk page 1'
      fill_in 'Url', with: link

      click_on 'add link'

      within page.all('.nested-fields')[1] do
        fill_in 'Link name', with: 'vk page 2'
        fill_in 'Url', with: link, match: :prefer_exact
      end

      click_on 'Ask'

      expect(page).to have_content 'test question'
      expect(page).to have_link 'vk page 1', href: link
      expect(page).to have_link 'vk page 2', href: link
    end
  end
end

