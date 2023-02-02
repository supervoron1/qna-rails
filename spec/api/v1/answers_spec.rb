require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'Accept': 'application/json' } }

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

  describe 'POST /api/v1/questions/{id}/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers

          expect(response).to have_http_status :created
        end

        it 'saves a new answer in the database' do
          expect { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers }.
            to change(user.answers, :count).by(1)
        end

        it 'returns fields that was send in parameters' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers

          %w[body].each do |attr|
            expect(json['answer'][attr]).to eq attributes_for(:answer)[attr.to_sym]
          end
        end
      end

      context 'with invalid attributes' do
        it 'returns 400 status code' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers

          expect(response).to have_http_status :bad_request
        end

        it 'does not save the question' do
          expect { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers }.
            to_not change(Answer, :count)
        end

        it 'should contain key errors' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers

          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/{id}' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'own answer' do
        before { answer.update(user_id: user.id) }

        context 'with valid attributes' do
          before { patch api_path, params:
            { access_token: access_token.token, answer: { body: 'new body' } }, headers: headers }

          it 'returns 200 status code' do
            expect(response).to be_successful
          end

          it 'changes answer attributes' do
            answer.reload

            expect(answer.body).to eq 'new body'
          end
        end

        context 'with invalid attributes' do
          before { patch api_path, params:
            { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers }

          it 'returns 400 status code' do
            expect(response).to have_http_status :bad_request
          end

          it 'does not change answer' do
            answer.reload

            expect(answer.body).to eq 'Answer_Body'
          end

          it 'should contain key errors' do
            expect(json).to have_key('errors')
          end
        end
      end

      context 'not own answer' do
        let(:another_user) { create(:user) }

        before do
          answer.update(user_id: another_user.id)

          patch api_path, params:
            { access_token: access_token.token, answer: { body: 'new body' } }, headers: headers
        end

        it 'returns 403 status code' do
          expect(response).to have_http_status :forbidden
        end

        it 'does not change question' do
          answer.reload

          expect(answer.body).to eq 'Answer_Body'
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/{id}' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'own answer' do
        before { answer.update(user_id: user.id) }

        it 'returns 204 status code' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          expect(response).to have_http_status :no_content
        end

        it 'deletes the answer' do
          expect { delete api_path, params:
            { access_token: access_token.token }, headers: headers }.to change(user.answers, :count).by(-1)
        end
      end

      context 'no own answer' do
        it 'returns 403 status code' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          expect(response).to have_http_status :forbidden
        end

        it "does not delete not the own answer" do
          answer.reload # TODO: for some reason doesn't work without it
          expect { delete api_path, params:
            { access_token: access_token.token}, headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end
end