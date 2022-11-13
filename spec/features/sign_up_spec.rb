require 'rails_helper'

feature 'User can sign up', %q{
  In order to get answer from a community
  As an unauthenticated user
  I'd like to be able to sign up
} do

  background do
    visit new_user_registration_path
    fill_in 'Email', with: 'email@test.com'
  end

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    fill_in 'Password', with: '12345'
    fill_in 'Password confirmation', with: '12345'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'Unregistered user tries to sign up with no matched passwords' do
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '12345'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Already registered user tries to sign up again' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content "Email has already been taken"
  end
end