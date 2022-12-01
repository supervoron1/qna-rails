require 'rails_helper'

feature 'User can delete attached files', %q{
  In order to delete unwanted attached files
  As an authenticated user
  I'd like to be able to delete attachment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, user: user) }
  given(:not_own_question) { create(:question, :with_file) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'deletes his attachment' do
      visit question_path(question)
      click_on 'Delete attachment'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario "deletes not his attachment" do
      visit question_path(not_own_question)

      expect(page).to_not have_link('Delete attachment')
    end
  end

  describe 'Unauthenticated user' do
    scenario "deletes attachment" do
      visit question_path(question)

      expect(page).to have_no_link('Delete attachment')
    end
  end
end