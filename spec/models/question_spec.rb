require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to :user }
  it { should belong_to(:best_answer).dependent(:destroy).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'handles_best_answers' do
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

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)

      question.save!
    end
  end
end
