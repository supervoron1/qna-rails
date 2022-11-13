require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: answer.question } }

    it 'assigns a new Answer to @answers' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer related to question in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) } }.to change(answer.question.answers, :count).by(1)
      end

      it 'saves a new answer related to user in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) } }.to change(user.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        question_id = answer.question.id
        expect { post :create, params: { question_id: question_id, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders question view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    context 'own answer' do
      before { answer.update(user_id: user.id) }

      before { get :edit, params: { question_id: answer.question, id: answer } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'no own answer' do
      before { get :edit, params: { question_id: answer.question, id: answer } }

      it 'redirects to question' do
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'own answer' do
      before { answer.update(user_id: user.id) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer) }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } }
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'redirects to upload answer' do
          patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer, :invalid) } }

        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq 'Answer_Body'
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
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
