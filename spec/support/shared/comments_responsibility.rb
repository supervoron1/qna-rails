shared_examples_for 'Comments responsibility' do
  let(:comment) { comments.first }
  let(:comment_response) { object_response['comments'].first }

  it 'returns list of comments' do
    expect(object_response['comments'].size).to eq comments.size
  end

  it 'returns all public fields of comments' do
    %w[id body user_id created_at updated_at user_id ].each do |attr|
      expect(comment_response[attr]).to eq comment.send(attr).as_json
    end
  end

  it 'does not return private fields of comments' do
    %w[commentable_type commentable_id].each do |attr|
      expect(comment_response).to_not have_key(attr)
    end
  end
end