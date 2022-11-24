require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:gist_url) { 'https://gist.github.com/supervoron1/7941634873e5677826a20404ae2fbc03' }
    given(:another_gist_url) { 'https://gist.github.com/supervoron1/9e1bf0ef3a6710c70b2b4c7738c6b12a' }

    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My Gist'
    end

    scenario 'adds link when gives an answer' do
      fill_in 'Url', with: gist_url

      click_on 'Submit answer'

      within '.answers' do
        expect(page).to have_link 'My Gist', href: gist_url
      end
    end

    scenario 'adds two links when gives an answer' do
      fill_in 'Url', with: gist_url

      click_on 'add link'

      first(:field, 'Link name').fill_in with: 'Another Gist'
      first(:field, 'Url').fill_in with: another_gist_url

      click_on 'Submit answer'

      within '.answers' do
        expect(page).to have_link 'My Gist', href: gist_url
        expect(page).to have_link 'Another Gist', href: another_gist_url
      end
    end

    scenario 'adds link with incorrect URL when gives an answer' do
      fill_in 'Url', with: 'blablaURL'

      click_on 'Submit answer'

      within '.answer-errors' do
        expect(page).to have_text 'Links url is not a valid HTTP URL'
      end
    end
  end
end