module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class DocumentNotFound < StandardError; end
  class Validations < StandardError; end

  included do

    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from Mongoid::Errors::DocumentNotFound, with: :four_zero_four
    rescue_from Mongoid::Errors::Validations, with: :mongoid_validation
    rescue_from ActionController::ParameterMissing, with: :four_twenty_two
    rescue_from AASM::InvalidTransition, with: :state_transition_err

  end

  private

  def state_transition_err(exception)
    errors = { error: ""}
    errors[:error] = "Cannot switch %{state_attr_name} from %{current_state_name} via %{event_name}" % {
        state_attr_name: exception.object.class.human_attribute_name(:aasm_state).downcase,
        current_state_name: exception.originating_state.to_s,
        event_name: exception.event_name.to_s
    }
    render json: errors, status: :unprocessable_entity
  end

  def mongoid_validation(exception)
    errors = { error: "", details: {} }
    errors[:error] = (exception.try(:record).try(:errors).try(:full_messages) || []).join(", ")
    errors[:details] = (exception.try(:record).try(:errors) || {})
    render json: { message: errors}, status: :unprocessable_entity
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def four_zero_four(exception)
    render json: { message: exception.message }, status: :not_found
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    render json: { message: e.message }, status: :unauthorized
  end

end