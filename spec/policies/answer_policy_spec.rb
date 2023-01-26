require 'rails_helper'
require_relative 'shared/votable_policy'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is exists' do
      expect(subject).to permit(user)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil)
    end
  end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:answer))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:answer))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :mark_as_best? do
    let(:question) { create(:question, user: user) }

    it 'grants access if user is author of question' do
      expect(subject).to permit(user, create(:answer, question: question))
    end

    it 'denies access if user is not author of question' do
      expect(subject).not_to permit(user, create(:answer))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :comment? do
    it 'grants access if user is exists' do
      expect(subject).to permit(user)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil)
    end
  end

  it_behaves_like 'Votable Policy' do
    let!(:votable) { create(:answer) }
    let(:factory_name) { :answer }
  end
end
