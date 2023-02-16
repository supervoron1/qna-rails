require 'rails_helper'

RSpec.describe FulltextSearch do
  it 'searches the entire DB' do
    subject = FulltextSearch.new('test', 'all')
    allow(ThinkingSphinx).to receive(:search).with('test', classes: [Question, Answer, Comment, User], page: 1)
    subject.call
  end

  it 'searches with correct scope' do
    subject = FulltextSearch.new('test', 'questions')
    allow(Question).to receive(:search).with('test', page: 1)
    subject.call
  end
end