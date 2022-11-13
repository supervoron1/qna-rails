require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should belong_to(:best_answer).dependent(:destroy).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  context 'not best answers method' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:another_answer) { create(:answer, question: question) }
    let(:best_answer) { create(:answer, question: question) }

    before { best_answer.mark_as_best! }

    it 'returns all not best answers' do
      expect(question.not_best_answers).to include(answer, another_answer)
    end

    it "doesn't return best answer" do
      expect(question.not_best_answers).to_not include(best_answer)
    end
  end
end
