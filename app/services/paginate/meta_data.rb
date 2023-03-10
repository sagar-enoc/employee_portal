# frozen_string_literal: true

class Paginate::MetaData < Paginate::Base
  def initialize(paginator:, scope:, paginated_data:, query:)
    @paginator = paginator
    @paginated_data = paginated_data
    super(scope:, query:)
  end

  def call
    return cursor_meta_data if paginator.is_a?(Paginate::ByCursor)

    deferred_joins_meta_data
  end

  private

  attr_reader :paginator, :paginated_data

  def deferred_joins_meta_data
    {
      per_page:,
      total_count:,
      total_pages:,
      current_page: page
    }
  end

  def cursor_meta_data
    {
      per_page:,
      before_cursor: result_cursor_keys.first,
      after_cursor: result_cursor_keys.last
    }
  end

  def result_cursor_keys
    @result_cursor_keys ||= paginated_data.pluck(query[:cursor_key].to_sym)
  end

  def total_count
    @total_count ||= scope.unscope(:limit, :offset).size
  end

  def total_pages
    (total_count / per_page.to_f).ceil
  end
end
