require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:file) { create(:question, :with_file).files.first }

  subject { described_class }

  permissions :destroy? do
    it 'grants access if user is admin' do

      expect(subject).to permit(User.new(admin:true), file)
    end

    it 'grants access if user is author of parent resource' do
      file.record.update(user: user)

      expect(subject).to permit(user, file)
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, file)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, file)
    end
  end
end