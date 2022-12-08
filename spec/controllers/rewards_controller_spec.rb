require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:empty_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, user: user) }
  let!(:rewards) { create_list(:reward, 3, question: question, answer: answer) }

  describe 'GET #index' do
    it 'populates an array of all users rewards' do
      login(user)
      get :index

      expect(assigns(:rewards)).to match_array(rewards)
    end

    it "populates empty array if user doesn't have rewards" do
      login(empty_user)
      get :index

      expect(assigns(:rewards)).to be_empty
    end

    it 'renders index view' do
      login(user)
      get :index

      expect(response).to render_template :index
    end
  end
end
