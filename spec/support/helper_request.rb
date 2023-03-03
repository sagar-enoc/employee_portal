# frozen_string_literal: true

module HelperRequest
  def parsed_response_body
    JSON.parse(response.body).deep_transform_keys { |k| k.underscore.to_sym }
  end

  def json_data
    parsed_response_body[:data]
  end

  def json_errors
    parsed_response_body[:errors]
  end

  def json_meta
    parsed_response_body[:meta]
  end

  def json_pagination
    json_meta[:pagination]
  end

  %i[get post patch].each do |method|
    define_method(method) do |url, *attrs|
      # Inject 'Content-Type' in every request headers by default.
      attrs = attrs.first || {}
      attrs[:headers] = { 'Content-Type' => 'application/json' }.merge(attrs[:headers] || {}).compact
      super url, **attrs
    end
  end
end
