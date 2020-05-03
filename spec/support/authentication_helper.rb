module AuthenticationHelper
  def sign_in_as_a_valid_user
    @user || FactoryBot.create(:user)
    @auth_params = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@user.access_token) }
  end
end