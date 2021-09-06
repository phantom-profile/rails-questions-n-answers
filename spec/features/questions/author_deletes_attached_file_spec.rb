feature 'Only user can delete files of his question', "
  In order to remove file in question by myself
  As a auth user
  I'd like to delete file in question and do not allow to delete it by others
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:files) { [blob_for('test_1.txt').signed_id] }

  describe 'auth user', js: true do
    background do
      sign_in user_one
    end

    scenario 'tries to delete file in his own question' do
      user_one.questions.create(title: 'title 1', body: 'body 1', files: files)
      visit questions_path

      expect(page).to have_link 'test_1.txt'
      expect(page).to have_link 'Remove'

      click_on 'Remove'
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_link 'test_1.txt'
    end

    scenario 'tries to delete file in not his question' do
      user_two.questions.create(title: 'title 1', body: 'body 1', files: files)
      visit questions_path

      expect(page).to have_link 'test_1.txt'
      expect(page).not_to have_link 'Remove'
    end
  end

  scenario 'not auth user tries to delete file', js: true do
    user_one.questions.create(title: 'title 1', body: 'body 1', files: files)
    visit questions_path

    expect(page).to have_link 'test_1.txt'
    expect(page).not_to have_link 'Remove'
  end
end

