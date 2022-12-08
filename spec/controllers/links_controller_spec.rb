require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'own question' do
      before { question.update(user_id: user.id) }

      it 'deletes link' do
        puts question.links
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
      end
    end

    context 'not own question' do
      it "doesn't delete not own question" do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: link.id }, format: :js
        expect(response).to redirect_to question
      end
    end
  end
end
