require 'rails_helper'

feature 'User can answer to question', %q{
  In order to add answer to community
  As an authenticated user
  I'd like to be able to answer to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers to question' do
      fill_in 'Body', with: 'answer answer!'
      click_on 'Submit answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer answer!'
      end
    end

    scenario 'answers to question with attached files' do
      fill_in 'Body', with: 'answer answer!'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Submit answer'

      within '.answer' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'answers to question with errors' do
      fill_in 'Body', with: ''
      click_on 'Submit answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to answer to question' do
      visit question_path(question)
      fill_in 'Body', with: 'answer'
      click_on 'Submit answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'With multiple sessions', js: true do
    scenario 'answer appears on another users pages' do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        fill_in 'Body', with: 'answer answer!'
        click_on 'Submit answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('answer answer!')
      end
    end
  end
end