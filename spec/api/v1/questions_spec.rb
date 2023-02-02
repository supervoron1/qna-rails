require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'Content-Type': 'application/json',
                    'Accept': 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[user_id best_answer_id].each do |attr|
          expect(question_response).to_not have_key(attr)
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq answers.size
        end

        it 'returns all public fields of answer' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'does not return private fields of answer' do
          %w[user_id].each do |attr|
            expect(answer_response).to_not have_key(attr)
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/{id}' do
    let!(:question) { create(:question, :with_file) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'does not return private fields of question' do
        %w[user_id].each do |attr|
          expect(question_response).to_not have_key(attr)
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq comments.size
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
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq question.files.size
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
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq links.size
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

  describe 'GET /api/v1/questions/{id}/answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }
    let(:answer) { answers.first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end

      it 'returns all public fields of answer' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'does not return private fields of answer' do
        %w[user_id].each do |attr|
          expect(answer_response).to_not have_key(attr)
        end
      end
    end
  end
end