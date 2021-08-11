feature 'User can look at question list', "
  In order to solve different problems described on site
  As a user
  I'd like to look at question list
" do
  given!(:questions) { create_list(:question, 5) }

  scenario 'check root page with questions' do
    visit root_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[4].title
  end
end
