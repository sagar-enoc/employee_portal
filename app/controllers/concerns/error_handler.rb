# frozen_string_literal: true

module ErrorHandler
  def self.included(action)
    action.class_eval do
      # 5xx - server errors
      rescue_from StandardError, with: :server_error

      # 4xx
      rescue_from Error::V1::AuthenticationInvalid, with: :authentication_error
      rescue_from ActionController::BadRequest, with: :bad_request_error
      rescue_from ActionController::UnknownHttpMethod, with: :bad_request_error
    end
  end

  private

  def bad_request_error(error)
    render_errors(:bad_request, error)
  end

  def server_error(error)
    render_errors(:internal_server_error, error)
  end

  def render_errors(status, error)
    # raise error unless Rails.env.production?

    render(
      json: { errors: error.message },
      status:,
      content_type: 'application/json'
    )
  end

  def authentication_error(error)
    response.set_header('WWW-Authenticate', 'Basic realm="Accessing /v1", charset="UTF-8"')
    render_errors(:unauthorized, error)
  end
end
