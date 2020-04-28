class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  rescue_from Mongoid::Errors::DocumentNotFound, with: :four_zero_four
  rescue_from Mongoid::Errors::Validations, with: :four_twenty_two

  #include ExceptionHandler
  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def four_zero_four(e)
    render json: { message: e.message }, status: :not_found
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      User.find_by(access_token: token)
    end
  end

  def current_user
    @current_user ||= authenticate
  end
end
