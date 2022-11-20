require 'rails_helper'

feature 'User can edit question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    given(:another_question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question' do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text?'
        click_on 'Save'
      end

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text?'
    end

    scenario 'edits his question with attached files' do
      within '.question' do
        click_on 'Edit question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "edits question with errors" do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "edits not his question" do
      visit question_path(another_question)

      expect(page).to have_no_link('Edit question')
    end
  end

  context 'Unauthenticated user' do
    scenario "edits question" do
      visit question_path(question)

      expect(page).to have_no_link('Edit question')
    end
  end
end