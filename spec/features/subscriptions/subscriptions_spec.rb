require 'rails_helper'

feature 'User can subscribe for question', %q{
  In order to get new answers of question via mail
  As an authenticated user
  I'd like to be able to subscribe for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'subscribe for question' do
      within '.question' do
        click_on 'Subscribe for answers'

        expect(page).to_not have_link 'Subscribe for answers'
        expect(page).to have_link 'Unsubscribe'
      end

      expect(page).to have_text('You have successfully subscribed for new answers')

    end

    scenario 'unsubscribe from question' do
      let(:subscription) { create(:subscribtion, question: question, user: user) }
      within '.question' do
        click_on 'Unsubscribe'

        expect(page).to have_link 'Subscribe for answers'
        expect(page).to_not have_link 'Unsubscribe'
      end

      expect(page).to have_text('You have unsubscribed from this question')
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'subscribe for question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Subscribe for answers'
      end
    end
  end
end