# frozen_string_literal: true

module Paginable
  def paginate_scope
    return unless scope

    paginated_data
  end

  def page_meta_data
    return {} unless scope

    Paginate::MetaData.call(paginator:, scope:, paginated_data:, query:)
  end

  private

  def paginator
    @paginator ||= PaginatorFacade.call(scope:, query:, default_order:, allowed_cursor_keys:)
  end

  def paginated_data
    @paginated_data ||= paginator.call
  end
end
