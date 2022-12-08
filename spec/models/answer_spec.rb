require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_one(:question_with_best_answer).dependent(:nullify) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    it 'marks answer as the best for the question' do
      answer.mark_as_best!
      expect(question.best_answer).to eq answer
    end
  end

  describe 'is_best?' do
    let(:answer) { create(:answer) }

    it 'is false if not marked as best' do
      expect(answer).not_to be_best
    end

    it 'is true if marked as best' do
      answer.mark_as_best!
      expect(answer).to be_best
    end
  end
end
