class FileSerializer < ActiveModel::Serializer
  attributes :id, :url_path

  def url_path
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end
