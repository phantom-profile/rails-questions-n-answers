# frozen_string_literal: true

feature 'User can see gist istead  of link', "
  In order to have detailed gist description
  As a user
  I'd like to see gist description instead of link
" do
  given(:gist_link) { [Link.new(name: 'test_gist', url: 'https://gist.github.com/b0531fdef21bde3e0777ff5c89a3600c')] }
  given!(:question) { create(:question, title: 'gist_question', links: gist_link) }

  scenario 'display gist description to question' do
    visit questions_path

    expect(page).to have_content 'gist_question'
    expect(page).to have_content 'Вопрос из теста html с сайта TestGuru'

    expect(page).to have_link 'Link to gist - test_gist'
  end
end
