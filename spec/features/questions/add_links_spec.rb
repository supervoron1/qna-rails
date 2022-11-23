require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }


  describe 'Authenticated user', js: true do
    given(:gist_url) { 'https://gist.github.com/supervoron1/7941634873e5677826a20404ae2fbc03' }
    given(:another_gist_url) { 'https://gist.github.com/supervoron1/9e1bf0ef3a6710c70b2b4c7738c6b12a' }

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My Gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'adds link when asks question' do
      click_on 'Ask'

      expect(page).to have_link 'My Gist', href: gist_url
    end

    scenario 'adds two links when asks question' do
      click_on 'add link'

      first(:field, 'Link name').fill_in with: 'Another Gist'
      first(:field, 'Url').fill_in with: another_gist_url

      click_on 'Ask'

      expect(page).to have_link 'My Gist', href: gist_url
      expect(page).to have_link 'Another Gist', href: another_gist_url
    end
  end

end