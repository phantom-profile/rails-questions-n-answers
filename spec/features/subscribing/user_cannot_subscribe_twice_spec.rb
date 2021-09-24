# frozen_string_literal: true

feature 'User cannot subscribe twice', "
  In order to have only one letter for one question
  As an auth user
  I'd like to subscribe only once
" do
  given(:user) { create(:user) }

  scenario 'subscribes for resource and disabled to repeat subscribing' do
    create(:question)

    sign_in user
    visit questions_path
    click_on 'receive update news'

    expect(page).to have_content 'successfully subscribed'
    expect(page).not_to have_content 'receive update news'
  end
end

