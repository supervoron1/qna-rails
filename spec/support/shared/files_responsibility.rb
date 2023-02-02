shared_examples_for 'Files responsibility' do
  let(:file) { object.files.first }
  let(:file_response) { object_response['files'].first }

  it 'returns list of files' do
    expect(object_response['files'].size).to eq object.files.size
  end

  it 'returns path for file' do
    expect(file_response['url_path']).to eq Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  it 'returns id for file' do
    expect(file_response['id']).to eq file.id
  end
end