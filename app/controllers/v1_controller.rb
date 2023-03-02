# frozen_string_literal: true

class V1Controller < ActionController::API
  include ErrorHandler, ApiAuthenticator
end
