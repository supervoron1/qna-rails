require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'by not subscriber' do
      before { login(user) }

      it 'saves subscribe to the database' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to change(Subscription, :count).by(1)
      end

      it 'saves a new subscribe related to user in the database' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to change(user.subscriptions, :count).by(1)
      end

      it 'saves a new subscribe related to question in the database' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to change(question.subscriptions, :count).by(1)
      end
    end

    context 'by subscriber' do
      before do
        login(user)
        Subscription.create(user: user, question: question)
      end

      it 'doesnt save subscribe to the database' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to_not change(Subscription, :count)
      end
    end

    context 'by unauthorized user' do
      it 'doesnt save subscribe to the database' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:subscription) { create(:subscription, question: question) }
    context 'by subscriber' do
      before do
        login(user)
        subscription.update(user: user)
      end

      it 'deletes subscribe from the database' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(user.subscriptions, :count).by(-1)
      end
    end

    context 'by not subscriber' do
      before do
        login(user)
      end

      it 'does not delete subscribe from the database' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to_not change(Subscription, :count)
      end
    end

    context 'by unauthorized user' do
      it 'does not delete subscribe from the database' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end
end
