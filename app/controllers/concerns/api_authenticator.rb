# frozen_string_literal: true

module ApiAuthenticator
  extend ActiveSupport::Concern

  included do
    before_action :ensure_authenticated!
  end

  private

  def ensure_authenticated!
    return if request.headers['X-API-Secret'] == Rails.configuration.env_vars.api_secret

    raise Error::V1::AuthenticationInvalid, I18n.t('v1.errors.authentication.invalid_token')
  end
end
