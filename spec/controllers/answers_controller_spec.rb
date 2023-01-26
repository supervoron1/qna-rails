require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer related to question in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :json }.to change(Answer, :count).by(1)
      end

      it 'saves a new answer related to user in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :json }.to change(user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }, format: :json }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'own answer' do
      before { answer.update(user_id: user.id) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq 'Answer_Body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'not own answer' do
      before { patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Answer_Body'
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'own answer' do
      before { answer.update(user_id: user.id) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: answer.question, id: answer }, format: :js }.to change(user.answers, :count).by(-1)
      end
    end

    context 'not own answer' do
      it "doesn't delete not own answer" do
        answer.reload
        expect { delete :destroy, params: { question_id: answer.question, id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'returns 403 Forbidden' do
        delete :destroy, params: { question_id: answer.question, id: answer }, format: :js
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'PATCH #best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    before { login(user) }

    context 'own question' do
      before { question.update(user: user) }

      it 'changes best answer' do
        patch :mark_as_best, params: { id: answer.id }, format: :js
        question.reload
        expect(question.best_answer).to eq answer
      end

      it 're-render index view' do
        patch :mark_as_best, params: { id: answer.id }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'not own question' do
      it 'doesn\t change best answer' do
        puts user.author_of?(question)
        patch :mark_as_best, params: { id: answer.id }, format: :js
        question.reload
        expect(question.best_answer).to_not eq answer
      end

      it 'returns 403 Forbidden' do
        patch :mark_as_best, params: { id: answer.id }, format: :js
        expect(response).to have_http_status 403
      end
    end
  end
end
