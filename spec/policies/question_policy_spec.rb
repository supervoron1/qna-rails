require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :index? do
    it 'grant access to all users' do
      expect(subject).to permit(nil)
    end
  end

  permissions :show? do
    it 'grants access to all users' do
      expect(subject).to permit(nil)
    end
  end

  permissions :new? do
    it 'grants access if user is exists' do
      expect(subject).to permit(user)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil)
    end
  end

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
      expect(subject).to permit(User.new(admin: true), create(:question))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:question, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:question, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end
end
