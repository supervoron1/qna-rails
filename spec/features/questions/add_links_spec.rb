require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }


  describe 'Authenticated user', js: true do
    given(:simple_link) { 'https://google.com' }
    given(:another_link) { 'https://yandex.ru' }

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'Google'
    end

    scenario 'adds link when asks question' do
      fill_in 'Url', with: simple_link

      click_on 'Ask'

      expect(page).to have_link 'Google', href: simple_link
    end

    scenario 'adds two links when asks question' do
      fill_in 'Url', with: simple_link

      click_on 'add link'

      first(:field, 'Link name').fill_in with: 'Yandex'
      first(:field, 'Url').fill_in with: another_link

      click_on 'Ask'

      expect(page).to have_link 'Google', href: simple_link
      expect(page).to have_link 'Yandex', href: another_link
    end

    scenario 'adds link with incorrect URL' do
      fill_in 'Url', with: 'some_gibberish_url'

      click_on 'Ask'

      expect(page).to have_text 'Links url is not a valid HTTP URL'
    end

    scenario 'adds link with gist when asks question', js: true do
      fill_in 'Url', with: 'https://gist.github.com/supervoron1/7941634873e5677826a20404ae2fbc03'

      click_on 'Ask'

      expect(page).to have_content 'qna test gist'
    end
  end

end