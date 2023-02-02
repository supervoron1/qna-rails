shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status code if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status code if access_token in invalid' do
      do_request(method, api_path, params: { access_token: '12345' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end