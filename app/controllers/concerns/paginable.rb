# frozen_string_literal: true

module Paginable
  def paginate_scope
    return unless scope

    PaginatorFacade.call(scope:, query:, default_order:, allowed_cursor_keys:)
  end
end
