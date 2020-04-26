module ExceptionHandler
  extend ActionSupport::Concern

  class AuthenticationError < StandardError; end
  class DocumentNotFound < StandardError; end
  class Validations < StandartError; end

  included do

    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from Mongoid::Errors::DocumentNotFound, with: :four_zero_four
    rescue_from Mongoid::Errors::Validations, with: :four_twenty_two
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def four_zero_four
    render json: { message: e.message }, status: :not_found
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    render json: { message: e.message }, status: :unauthorized
  end

end