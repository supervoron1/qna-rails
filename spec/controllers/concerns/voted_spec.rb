require 'rails_helper'

shared_examples_for 'voted' do
  let!(:controller) { described_class }
  let!(:votable) { create(controller.controller_name.classify.downcase.to_sym) }
  let!(:voted_votable) { create(controller.controller_name.classify.downcase.to_sym) }
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:vote) { create(:vote, user: user, votable: voted_votable) }

  describe 'POST #like' do
    context 'by not votable user' do
      before { login(user) }

      it 'saves vote to the database' do
        expect { post :like, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'saves vote value equal 1' do
        post :like, params: { id: votable }, format: :json
        expect(votable.votes.first.value).to eq(1)
      end
    end

    context 'by already votable user' do
      before { login(user) }

      it 'doesnt save vote to the database' do
        expect { post :like, params: { id: voted_votable }, format: :json }.to_not change(votable.votes, :count)
      end
    end

    context 'by unauthorized user' do
      it 'doesnt save vote to the database' do
        expect { post :like, params: { id: voted_votable }, format: :json }.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'POST #dislike' do
    before { login(user) }

    context 'by not votable user' do
      it 'saves vote to the database' do
        expect { post :dislike, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'saves vote with value equal 1' do
        post :dislike, params: { id: votable }, format: :json
        expect(votable.votes.first.value).to eq(-1)
      end
    end

    context 'by already votable user' do
      it 'doesnt save vote to the database' do
        expect { post :dislike, params: { id: voted_votable }, format: :json }.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'DELETE #cancel' do
    before { login(user) }

    context 'already voted votable' do
      it 'removes vote from the database' do
        expect { delete :cancel, params: { id: voted_votable }, format: :json }.to change(voted_votable.votes, :count).by(-1)
      end
    end

    context 'not voted votable' do
      it 'doesnt remove vote from the database' do
        expect { delete :cancel, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end
    end
  end
end