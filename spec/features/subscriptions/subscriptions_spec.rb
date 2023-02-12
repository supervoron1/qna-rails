require 'rails_helper'

feature 'User can subscribe for question', %q{
  In order to get new answers of question via mail
  As an authenticated user
  I'd like to be able to subscribe for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    context 'author of question' do
      before { visit new_question_path }

      scenario 'subscribe for question after create' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text?'
        click_on 'Ask'

        within '.question' do
          expect(page).to_not have_link 'Subscribe to new answers'
          expect(page).to have_link 'Unsubscribe'
        end
      end
    end

    context 'not author of question' do
      scenario 'subscribe for question' do
        visit question_path(question)

        within '.question' do
          click_on 'Subscribe to new answers'

          expect(page).to_not have_link 'Subscribe for answers'
          expect(page).to have_link 'Unsubscribe'
        end
      end

      scenario 'unsubscribe from question' do
        Subscription.create(question: question, user: user)
        visit question_path(question)

        within '.question' do
          click_on 'Unsubscribe'

          expect(page).to have_link 'Subscribe to new answers'
          expect(page).to_not have_link 'Unsubscribe'
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'subscribe for question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Subscribe to new answers'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end
end
