require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer related to question in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :js }.to change(answer.question.answers, :count).by(1)
      end

      it 'saves a new answer related to user in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        question_id = answer.question.id
        expect { post :create, params: { question_id: question_id, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders question view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :create
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

      it 're-renders edit view' do
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'own answer' do
      before { answer.update(user_id: user.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to change(user.answers, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: answer.question, id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'no own question' do
      it "doesn't delete not the own question" do
        answer.reload # TODO: for some reason doesn't work without it
        expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: answer.question, id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
