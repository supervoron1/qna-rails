require 'rails_helper'

feature 'User can make answer as best', %q{
  In order to make answer as best
  As an author of question
  I'd like to be able to make answer as best
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create(:answer, body: 'not best yet', question: question) }
  given!(:best_answer) { create(:answer, body: 'im the best', question: question, user: another_user) }

  describe 'Owner of question', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'marks answer as best' do
      within "div[data-answer_id='#{best_answer.id}']" do
        click_on 'Mark as best'
      end

      within '.best-answer' do
        expect(page).to have_text best_answer.body
        expect(page).to_not have_link 'Mark as best'
      end

      log_out
      sign_in(another_user)
      visit rewards_path

      expect(page).to have_css('img')
      expect(page).to have_text(reward.name)
    end
  end

  describe 'Not an owner of question' do
    scenario 'tries to mark answer as best' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link('Mark as best')
    end
  end
end