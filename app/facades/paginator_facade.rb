# frozen_string_literal: true

class PaginatorFacade < Base
  def initialize(scope:, query:, default_order:, allowed_cursor_keys: [])
    @scope = scope
    @query = query
    @default_order = default_order
    @allowed_cursor_keys = allowed_cursor_keys
  end

  def call
    if request_by_cursor?
      Paginate::ByCursor.call(scope:, query:, default_order:, allowed_cursor_keys:)
    else
      Paginate::ByDeferredJoin.call(scope:, query:, default_order:)
    end
  end

  private

  attr_reader :scope, :query, :default_order, :allowed_cursor_keys

  def request_by_cursor?
    query[:before_cursor].present? || query[:after_cursor].present?
  end
end
