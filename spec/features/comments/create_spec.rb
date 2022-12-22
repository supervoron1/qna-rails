require 'rails_helper'

feature 'User can comment question/answer', %q{
  In order to add comment to community
  As an authenticated user
  I'd like to be able to comment to question/answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments to question' do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'simple comment'
        click_on 'Save comment'

        expect(page).to have_content 'simple comment'
      end
    end

    scenario 'comments to answer' do
      within '.answer' do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'simple comment'
        click_on 'Save comment'

        expect(page).to have_content 'simple comment'
      end
    end

    scenario 'comments to question with errors' do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Your comment', with: ''
        click_on 'Save comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to answer to question' do
      visit question_path(question)
      expect(page).to_not have_link 'Comment'
    end
  end

  describe 'With multiple sessions', js: true do
    scenario 'comment appears on another users pages' do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          click_on 'Add comment'
          fill_in 'Your comment', with: 'simple comment'
          click_on 'Save comment'

          expect(page).to have_content 'simple comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('simple comment')
      end
    end
  end
end