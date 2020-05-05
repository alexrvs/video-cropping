module AuthenticationHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def auth_as_a_valid_user
    @user ||= FactoryBot.create(:user)
    @auth_params = { 'HTTP_AUTHORIZATION' => "Token #{@user.access_token}"}
  end
end