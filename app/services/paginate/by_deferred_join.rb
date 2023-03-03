# frozen_string_literal: true

class Paginate::ByDeferredJoin < Paginate::Base
  JOIN_QUERY = 'INNER JOIN (%s) as paged_scope ON %s.id = paged_scope.id'
  private_constant :JOIN_QUERY

  def call
    scope.all
      .then { |s| s.joins(format(JOIN_QUERY, page_query, scope.table_name)) }
  end

  def meta_data
    {
      per_page: per_page,
      current_page: page,
      total_count: total_count,
      total_pages: total_pages
    }
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

  def total_count
    @total_count ||= scope.unscope(:limit, :offset).size
  end

  def total_pages
    (total_count / per_page.to_f).ceil
  end
end
