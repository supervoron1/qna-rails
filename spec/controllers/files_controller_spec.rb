require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_file) }
  let(:answer) { create(:answer, :with_file, user: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'own attachment' do
      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: answer.files[0].id }, format: :js }.to change(answer.files, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer.files[0].id }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'not own attachment' do
      it "doesn't delete someone else's attachment" do
        expect { delete :destroy, params: { id: question.files[0].id } }.to_not change(question.files, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question.files[0].id }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
