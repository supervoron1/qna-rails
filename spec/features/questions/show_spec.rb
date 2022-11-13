require 'rails_helper'

feature 'User can see question and answers', %q{
  In order to get answer from a community
  As an (un)authenticated user
  I'd like to be able to see question and answers
} do

  before do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end

  describe 'Without answers' do
    given(:question) { create(:question) }

    scenario 'user sees question and message about no answers' do
      expect(page).to have_content "There are no any answers yet."
    end
  end

  describe 'With answers' do
    given(:question) { create(:question, :with_answers) }

    scenario 'user sees question and answers' do
      expect(page).to have_content(question.answers.first.body, count: 3)
    end
  end
end