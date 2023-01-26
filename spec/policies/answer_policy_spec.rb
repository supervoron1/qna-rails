require 'rails_helper'

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

  permissions :like? do
    let!(:answer) { create(:answer) }
    let(:vote) { create(:vote, votable: answer, user: user) }

    it 'grants access if user is not author of votable and did not vote before' do
      expect(subject).to permit(user, create(:answer))
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(:answer, user: user))
    end

    it 'denies access if user voted before' do
      # expect(subject).to_not permit(user, answer)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :dislike? do
    let!(:answer_with_vote) { create(:answer) }
    let(:vote) { create(:vote, votable: answer_with_vote, user: user) }

    it 'grants access if user is not author of votable and did not vote before' do
      expect(subject).to permit(user, create(:answer))
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(:answer, user: user))
    end

    it 'denies access if user voted before' do
      # expect(subject).to_not permit(user, answer_with_vote)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :cancel? do
    let!(:answer_with_vote) { create(:answer) }
    let(:vote) { create(:vote, votable: answer_with_vote, user: user) }

    it 'grants access if user voted before' do
      # expect(subject).to permit(user, answer_with_vote)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author of votable and did not vote before' do
      expect(subject).to_not permit(user, create(:answer))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end
end
