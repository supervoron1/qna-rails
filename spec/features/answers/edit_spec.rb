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

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'text text text?'
        click_on 'Save'

        expect(page).to_not have_content(answer.body)
        expect(page).to have_content 'text text text?'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with attached files' do
      click_on 'Edit answer'

      within '.answers' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "edits answer with errors" do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "edits not his answer" do
      visit question_path(another_question)

      expect(page).to have_no_link('Edit answer')
    end
  end

  describe 'Unauthenticated user' do
    scenario "edits answer" do
      visit question_path(question)

      expect(page).to have_no_link('Edit answer')
    end
  end
end