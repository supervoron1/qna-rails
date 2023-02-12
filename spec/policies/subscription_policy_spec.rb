require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  let(:subscriber) { create(:user) }
  let(:not_subscriber) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, question: question, user: subscriber) }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is not subscriber' do
      expect(subject).to permit(not_subscriber, create(:subscription, question: question))
    end

    it 'denies access if user is subscriber' do
      expect(subject).to_not permit(subscriber, create(:subscription, question: question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:subscription))
    end
  end

  permissions :destroy? do
    it 'grants access if user is subscriber' do
      expect(subject).to permit(subscriber, create(:subscription, question: question))
    end

    it 'denies access if user is not subscriber' do
      expect(subject).to_not permit(not_subscriber, create(:subscription, question: question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:subscription))
    end
  end
end
