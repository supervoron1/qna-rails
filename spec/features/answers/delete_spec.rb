require 'rails_helper'

feature 'User can delete answer', %q{
  In order to delete wrong answer
  As an authenticated user
  I'd like to be able to delete answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  # Don't know how to do it better
  given!(:another_question) { create(:question) }
  given!(:another_answer) { create(:answer, question: another_question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
    end

    scenario 'deletes his answer' do
      visit question_path(question)
      expect(page).to have_content 'Answer_Body'
      click_on 'Delete answer'

      expect(page).to_not have_content 'Answer_Body'
    end

    scenario "deletes not his answer" do
      visit question_path(another_question)

      expect(page).to have_no_link('Delete answer')
    end
  end

  context 'Unauthenticated user' do
    scenario "edits answer" do
      visit question_path(question)

      expect(page).to have_no_link('Delete answer')
    end
  end
end