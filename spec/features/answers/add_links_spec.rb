require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:simple_link) { 'https://google.com' }
    given(:another_link) { 'https://yandex.ru' }

    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'Google'
    end

    scenario 'adds link when gives an answer' do
      fill_in 'Url', with: simple_link

      click_on 'Submit answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: simple_link
      end
    end

    scenario 'adds two links when gives an answer' do
      fill_in 'Url', with: simple_link

      click_on 'add link'

      first(:field, 'Link name').fill_in with: 'Yandex'
      first(:field, 'Url').fill_in with: another_link

      click_on 'Submit answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: simple_link
        expect(page).to have_link 'Yandex', href: another_link
      end
    end

    scenario 'adds link with incorrect URL when gives an answer' do
      fill_in 'Url', with: 'blablaURL'

      click_on 'Submit answer'

      within '.answer-errors' do
        expect(page).to have_text 'Links url is not a valid HTTP URL'
      end
    end

    scenario 'adds link with gist when gives an answer' do
      fill_in 'Url', with: 'https://gist.github.com/supervoron1/7941634873e5677826a20404ae2fbc03'

      click_on 'Submit answer'

      within '.answer' do
        expect(page).to have_content 'qna test gist'
      end
    end
  end
end