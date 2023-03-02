# frozen_string_literal: true

module Paginable
  DEFAULT_PER_PAGE = 100
  MAX_PER_PAGE = 500
  private_constant :DEFAULT_PER_PAGE, :MAX_PER_PAGE

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
