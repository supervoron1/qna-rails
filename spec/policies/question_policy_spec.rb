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

  permissions :like? do
    let!(:question) { create(:question) }
    let(:vote) { create(:vote, votable: question, user: user) }

    it 'grants access if user is not author of votable and did\'t vote before' do
      expect(subject).to permit(user, create(:question))
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(:question, user: user))
    end

    it 'denies access if user voted before' do
      # expect(subject).to_not permit(user, question)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end

  permissions :dislike? do
    let!(:question_with_vote) { create(:question) }
    let(:vote) { create(:vote, votable: question_with_vote, user: user) }

    it 'grants access if user is not author of votable and did\'t vote before' do
      expect(subject).to permit(user, create(:question))
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(:question, user: user))
    end

    it 'denies access if user voted before' do
      # expect(subject).to_not permit(user, question_with_vote)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end

  permissions :cancel? do
    let!(:question_with_vote) { create(:question) }
    let(:vote) { create(:vote, votable: question_with_vote, user: user) }

    it 'grants access if user voted before' do
      # expect(subject).to permit(user, question_with_vote)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(:question, user: user))
    end

    it 'denies access if user is not author of votable and did\'t vote before' do
      expect(subject).to_not permit(user, create(:question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:question))
    end
  end
end
