# frozen_string_literal: true

class Error::V1::AuthenticationInvalid < StandardError
  attr_reader :message

  def initialize(message)
    @message = message
  end
end
