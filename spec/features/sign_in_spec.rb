require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: 'test_password'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'Sign in with GitHub' do
    expect(page).to have_content 'Sign in with GitHub'
    mock_auth_hash('github')
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account'
  end

  scenario 'Sign in with Google' do
    expect(page).to have_content 'Sign in with GoogleOauth2'
    mock_auth_hash('google_Oauth2')
    click_on 'Sign in with GoogleOauth2'

    expect(page).to have_content 'Successfully authenticated from Google account'
  end
end