require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new Link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'own question' do
      before { question.update(user_id: user.id) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'Question_title'
          expect(question.body).to eq 'Question_body'
        end

        it 're-renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'not own question' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'Question_title'
        expect(question.body).to eq 'Question_body'
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'own question' do
      before { question.update(user_id: user.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'no own question' do
      it "doesn't delete not the own question" do
        question.reload # TODO: for some reason doesn't work without it
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end
end
