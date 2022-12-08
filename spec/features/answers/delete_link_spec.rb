require 'rails_helper'

feature 'User can delete link from answer', %q{
  In order to delete wrong link from answer
  As an authenticated user
  I'd like to be able to delete link
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  given!(:another_question) { create(:question) }
  given!(:another_answer) { create(:answer, question: another_question) }
  given(:another_link) {create(:link, linkable: another_answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'deletes link from his answer' do
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_link link.name
    end

    scenario "deletes link from not his answer" do
      visit question_path(another_question)

      expect(page).to_not have_link('Delete link')
    end
  end

  describe 'Unauthenticated user' do
    scenario "deletes link" do
      visit question_path(question)

      expect(page).to_not have_link('Delete link')
    end
  end
end