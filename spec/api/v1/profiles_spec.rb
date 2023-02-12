require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'Content-Type': 'application/json',
                    'Accept': 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let(:api_path) { '/api/v1/profiles/others' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:other_users) { create_list(:user, 5) }
      let(:user) { other_users.first }
      let(:user_response) { json['users'].first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq other_users.size
      end

      it 'does not return auth user' do
        # get all users id from json
        users_id = json['users'].map{ |user| user['id'] }

        expect(users_id).to_not include(me.id)
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password admin].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end