# frozen_string_literal: true

class V1::EmployeesController < V1Controller
  include Paginable

  def index
    @employees =
      Employee.order(created_at: :desc)
        .limit(per_page)
        .offset(offset)
  end
end
