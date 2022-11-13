require 'rails_helper'

feature 'User can see questions', %q{
  In order to get answer from a community
  As an (un)authenticated user
  I'd like to be able to see list of questions
} do

  describe 'Without questions' do
    scenario 'user sees message about no questions' do
      visit questions_path

      expect(page).to have_content "There are no any questions. Let's create first"
    end
  end

  describe 'With questions' do
    given!(:questions) { create_list(:question, 3) }

    scenario 'user sees list of questions' do
      visit questions_path

      expect(page).to have_content(questions.first.title, count: 3)
    end
  end
end