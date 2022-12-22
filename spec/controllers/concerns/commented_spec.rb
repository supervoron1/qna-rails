require 'rails_helper'

shared_examples_for 'commented' do
  let!(:controller) { described_class }
  let!(:commentable) { create(controller.controller_name.classify.downcase.to_sym) }
  let(:user) { create(:user) }

  describe "POST #create" do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment related to question in the database' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :json }.to change(Comment, :count).by(1)
      end
      it 'saves a new comment related to commentable in the database' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :json }.to change(commentable.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:comment, :invalid_comment) }, format: :json }.to_not change(Comment, :count)
      end
    end
  end
end