require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct mistake in answer
  As an authenticated user
  I'd like to be able to edit answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  # Don't know how to do it better
  given!(:another_question) { create(:question) }
  given!(:another_answer) { create(:answer, question: another_question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
    end

    scenario 'edits his answer' do
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Body', with: 'text text text?'
      click_on 'Edit'

      expect(page).to have_content 'Your answer was successfully edited.'
      expect(page).to have_content 'text text text?'
    end

    scenario "edits answer with errors" do
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Body', with: ''
      click_on 'Edit'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "edits not his answer" do
      visit question_path(another_question)

      expect(page).to have_no_link('Edit answer')
    end
  end

  context 'Unauthenticated user' do
    scenario "edits answer" do
      visit question_path(question)

      expect(page).to have_no_link('Edit answer')
    end
  end
end