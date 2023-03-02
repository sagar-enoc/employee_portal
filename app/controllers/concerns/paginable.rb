# frozen_string_literal: true

module Paginable
  DEFAULT_PER_PAGE = 100
  MAX_PER_PAGE = 500
  JOIN_QUERY = 'INNER JOIN (%s) as paged_scope ON %s.id = paged_scope.id'
  private_constant :DEFAULT_PER_PAGE, :MAX_PER_PAGE, :JOIN_QUERY

  def paginate_scope
    return unless scope

    scope.all
      .then { |s| s.joins(format(JOIN_QUERY, page_query, scope.table_name)) }
  end

  private

  def page_query
    scope
      .order(default_order)
      .select(:id)
      .limit(per_page)
      .offset(offset)
      .to_sql
  end

  def page
    number = query[:page].to_i
    number.positive? ? number : 1
  end

  def per_page
    number = query[:per_page].to_i
    return DEFAULT_PER_PAGE unless number.positive?

    [number, MAX_PER_PAGE].min
  end

  def offset
    (page - 1) * per_page
  end
end
