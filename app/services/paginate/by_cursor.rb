# frozen_string_literal: true

class Paginate::ByCursor < Paginate::Base
  def initialize(scope:, query:, default_order:, allowed_cursor_keys:)
    @allowed_cursor_keys = allowed_cursor_keys
    super(scope:, query:, default_order:)
  end

  def call
    return results unless (error_key = fetch_error_key)

    raise Error::V1::ArgumentError, I18n.t("v1.errors.pagination.#{error_key}")
  end

  private

  attr_reader :allowed_cursor_keys

  def results
    @results ||=
      scope.all
        .then { |s| apply_keyset(s) }
        .then { |s| s.order(default_order) }
        .then { |s| s.limit(per_page) }
        .to_a
  end

  def valid_params?
    (query[:before_cursor].present? || query[:after_cursor].present?) && query[:cursor_key].present?
  end

  def fetch_error_key
    return :missing_cursors if query[:before_cursor].nil? && query[:after_cursor].nil?
    return :missing_cursor_key if query[:cursor_key].nil?

    :cursor_key_not_allowed unless allowed_cursor_keys.include?(query[:cursor_key].to_sym)
  end

  def apply_keyset(scope)
    if query[:before_cursor].present?
      scope.where("#{query[:cursor_key]} > ?", query[:before_cursor])
    elsif query[:after_cursor].present?
      scope.where("#{query[:cursor_key]} < ?", query[:after_cursor])
    else
      scope
    end
  end
end
