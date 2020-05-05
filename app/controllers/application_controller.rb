class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ExceptionHandler

  before_action :authenticate!

  protected

  def authenticate!
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(access_token: token)
    end
    @current_user || request_http_token_authentication
  end

  def current_user
    @current_user
  end

  def request_http_token_authentication(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: { error: "HTTP Token: Access denied."}, status: :unauthorized
  end
end
