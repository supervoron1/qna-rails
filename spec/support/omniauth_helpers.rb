module OmniauthHelpers
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new({
      'provider': provider.downcase,
      'uid': '123545',
      'info': {
        'email': 'mockuser@mail.ru'
      },
      'credentials': {
        'token': 'mock_token',
        'secret': 'mock_secret'
      }
    })

  end
end