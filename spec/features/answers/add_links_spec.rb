# frozen_string_literal: true

feature 'User can add link to answer', "
  In order to have detailed info in answer
  As an auth user
  I'd like to add link to resource in answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link) { 'https://vk.com/' }

  describe 'auth user', js: true do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'adds link to his answer' do
      fill_in 'Body', with: 'test answer'
      fill_in 'Link name', with: 'vk page'
      fill_in 'Url', with: link

      click_on 'Answer now'

      expect(page).to have_content 'test answer'
      expect(page).to have_link 'vk page', href: link
    end

    scenario 'adds many links to answer' do
      fill_in 'Body', with: 'test question'
      fill_in 'Link name', with: 'vk page 1'
      fill_in 'Url', with: link

      click_on 'add link'

      within page.all('.nested-fields')[1] do
        fill_in 'Link name', with: 'vk page 2'
        fill_in 'Url', with: link, match: :prefer_exact
      end

      click_on 'Answer now'

      expect(page).to have_content 'test question'
      expect(page).to have_link 'vk page 1', href: link
      expect(page).to have_link 'vk page 2', href: link
    end
  end

  describe 'auth user editing answer', js: true do
    background do
      user.answers.create(body: 'test answer', question: question)

      sign_in user

      visit question_path(question)
      click_on 'Edit answer'
      within '.answers' do
        click_on 'add link'
      end
    end

    scenario 'adds link to answer' do
      within '.answers' do
        fill_in 'Link name', with: 'vk page'
        fill_in 'Url', with: link

        click_on 'Save'

        expect(page).to have_content 'test answer'
        expect(page).to have_link 'vk page', href: link
      end
    end

    scenario 'adds many links to answer' do
      within '.answers' do
        fill_in 'Link name', with: 'vk page 1'
        fill_in 'Url', with: link

        click_on 'add link'

        within page.all('.nested-fields')[1] do
          fill_in 'Link name', with: 'vk page 2'
          fill_in 'Url', with: link, match: :prefer_exact
        end

        click_on 'Save'

        expect(page).to have_content 'test answer'
        expect(page).to have_link 'vk page 1', href: link
        expect(page).to have_link 'vk page 2', href: link
      end
    end
  end
end

