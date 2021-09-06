# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def blob_for(name)
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join(file_fixture(name)), 'rb'),
      filename: name,
      content_type: 'text/html'
    )
  end
end
