require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'verification of user authorship' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer) }

    it 'user is author of object' do
      expect(user).to be_author_of(question)
    end

    it 'user is not author of object' do
      expect(user).to_not be_author_of(answer)
    end
  end

  describe 'verification of user rewards' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:rewards) { create_list(:reward, 3, answer: answer) }

    it 'returns users rewards' do
      expect(user.rewards).to match_array(rewards)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth service' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
