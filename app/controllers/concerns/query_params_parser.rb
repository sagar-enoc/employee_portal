# frozen_string_literal: true

module QueryParamsParser
  def query
    @query ||= request.query_parameters.then do |qp|
      qp.deep_transform_keys { |k| k.underscore.to_sym }
    end
  end
end
