require 'sphinx_helper'

feature 'User can search for question', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
" do

  given!(:question) { create(:question, title: 'QuestionTitle') }

  scenario 'User searches for the question', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      ThinkingSphinx::Test.index

      within '.result' do
        expect(page).to_not have_content 'QuestionTitle'
      end

      fill_in 'q', with: 'QuestionTitle'
      choose 'Questions'

      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'QuestionTitle'
      end
    end
  end

  scenario 'User searches the entire DB for the question', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      fill_in 'q', with: 'QuestionTitle'
      choose 'All'

      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'QuestionTitle'
      end
    end
  end

  scenario 'User could not find the absent question', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      fill_in 'q', with: 'Missing question'
      choose 'Questions'

      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'No matches were found'
      end
    end
  end
end