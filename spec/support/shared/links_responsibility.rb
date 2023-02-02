shared_examples_for 'Links responsibility' do
  let(:link) { links.first }
  let(:link_response) { object_response['links'].first }

  it 'returns list of links' do
    expect(object_response['links'].size).to eq links.size
  end

  it 'returns all public fields of links' do
    %w[id url].each do |attr|
      expect(link_response[attr]).to eq link.send(attr).as_json
    end
  end

  it 'does not return private fields of links' do
    %w[name linkable_type linkable_id].each do |attr|
      expect(link_response).to_not have_key(attr)
    end
  end
end