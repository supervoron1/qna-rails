require 'rails_helper'

RSpec.describe LinkPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :destroy? do
    let(:question) { create(:question) }

    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin:true), create(:link, linkable: question))
    end

    it 'grants access if user is author of parent resource' do
      question.update(user: user)

      expect(subject).to permit(user, create(:link, linkable: question))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:link))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:link))
    end
  end
end