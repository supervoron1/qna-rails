require 'rails_helper'

feature 'User can delete link', %q{
  In order to delete wrong link
  As an authenticated user
  I'd like to be able to delete link
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:not_own_question) { create(:question)}
  given!(:link) { create(:link, linkable: question) }
  given(:another_link) {create(:link, linkable: not_own_question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
    end

    scenario 'deletes link from his question' do
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_link link.name
    end

    scenario "deletes link from not his question" do
      visit question_path(not_own_question)

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