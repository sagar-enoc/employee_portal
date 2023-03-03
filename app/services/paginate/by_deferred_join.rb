# frozen_string_literal: true

class Paginate::ByDeferredJoin < Paginate::Base
  JOIN_QUERY = 'INNER JOIN (%s) as paged_scope ON %s.id = paged_scope.id'
  private_constant :JOIN_QUERY

  def call
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
end
