# frozen_string_literal: true

module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def blob_for(name)
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join(file_fixture(name)), 'rb'),
      filename: name,
      content_type: 'text/html'
    )
  end
end
