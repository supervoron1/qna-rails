class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_authenticate('Github')
  end

  def google_oauth2
    oauth_authenticate('Google')
  end

  private

  def oauth_authenticate(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
