require 'rails_helper'

feature 'User can vote for liked question or answer', %q{
  In order to show like for question or answer
  As an authenticated user
  I'd like to be able to vote for it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'votes for question he liked' do
      within '.question' do
        click_on 'Like'

        expect(page).to have_text('Votes: 1')
        expect(page).to_not have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
    end

    scenario 'votes for disliked answer' do
      within '.answer' do
        click_on 'Dislike'

        expect(page).to have_text('Votes: -1')
        expect(page).to_not have_link 'Dislike'
        expect(page).to have_link 'Like'
      end
    end

    scenario 'votes for his own question' do
      question.update(user: user)

      within '.question' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end

    scenario 'changes decision and changes from like to dislike' do
      within '.question' do
        click_on 'Like'
        click_on 'Dislike'

        expect(page).to have_text('Votes: 0')
      end
    end
  end
end