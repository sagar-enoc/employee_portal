# frozen_string_literal: true

module Paginable
  def paginate_scope
    return unless scope

    paginator.call
  end

  def page_meta_data
    return {} unless scope

    paginator.meta_data
  end

  private

  def paginator
    @paginator ||= PaginatorFacade.call(scope:, query:, default_order:, allowed_cursor_keys:)
  end
end
