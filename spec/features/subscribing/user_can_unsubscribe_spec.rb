# frozen_string_literal: true

feature 'User can unsubscribe', "
  In order not to receive useless letters
  As an auth user
  I'd like to unsubscribe from useless resource
" do
  given(:user) { create(:user) }

  scenario 'auth user can remove his subscription' do
    question = create(:question)
    create(:subscription, user: user, subscriptable: question)

    sign_in user
    visit questions_path

    expect(page).to have_content "stop receiving update news"

    click_on 'stop receiving update news'

    expect(page).to have_content 'successfully unsubscribed'
    expect(page).to have_content 'receive update news'
  end
end
