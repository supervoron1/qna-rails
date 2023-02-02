require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'Content-Type': 'application/json',
                    'Accept': 'application/json' } }

  describe 'GET /api/v1/answers/{id}' do
    let!(:answer) { create(:answer, :with_file) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'does not return private fields of answer' do
        %w[user_id].each do |attr|
          expect(answer_response).to_not have_key(attr)
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq comments.size
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

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].first }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq answer.files.size
        end

        it 'returns path for file' do
          expect(file_response['url_path']).to eq Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        end

        it 'returns id for file' do
          expect(file_response['id']).to eq file.id
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq links.size
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
    end
  end
end