feature 'User can edit his own question', "
  In order to correct mistakes in question
  As an author of question
  I'd like to edit my question
" do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given!(:question) { user_one.questions.create(title: 'title 1', body: 'body 1') }

  scenario 'not auth user cannot edit questions' do
    visit questions_path

    expect(page).to have_content 'title 1'
    expect(page).not_to have_content 'Edit question'
  end

  describe 'auth user' do
    background do
      sign_in user_one
    end

    context 'is owner of question', js: true do
      background do
        visit questions_path
      end

      scenario 'edit question correctly' do
        click_on 'Edit question'

        within '.questions' do
          fill_in 'Body', with: 'edited test question'
          click_on 'Save'

          expect(page).not_to have_selector 'textarea'
        end

        expect(page).not_to have_content 'body 1'
        expect(page).to have_content 'edited test question'
      end

      scenario 'edit question not correctly' do
        click_on 'Edit question'

        within '.questions' do
          fill_in 'Body', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'is not owner and cannot edit question' do
      user_two.questions.create(body: 'question body 2', title: 'question title 2')

      visit questions_path

      expect(page).to have_content 'question body 2'
      expect(page).not_to have_content "question body 2\nEdit question"
    end
  end
end
