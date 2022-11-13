require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  context 'set best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    it 'user is author of object' do
      answer.mark_as_best!
      expect(question.best_answer).to eq answer
    end
  end
end
