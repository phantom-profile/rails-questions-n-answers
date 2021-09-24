class AttachmentSerializer < ActiveModel::Serializer
  attributes :filename, :url_to_file

  def url_to_file
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end
