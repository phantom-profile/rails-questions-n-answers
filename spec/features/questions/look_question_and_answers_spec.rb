# frozen_string_literal: true

feature 'User can look at question and answers', "
  In order to solve different problems described on site
  As a user
  I'd like to look at question and answers
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { question.answers.create(body: 'test answer', user: user) }

  # не хватает сценарий дла неаутентифицированного юзера
  # исправлено
  scenario 'not auth user checks show page with question and answer' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content answer.body
  end

  scenario 'auth user checks show page with question and answer' do
    sign_in user
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content answer.body
  end
end
