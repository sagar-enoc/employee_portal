# frozen_string_literal: true

class V1::EmployeesController < V1Controller
  include Paginable

  def index
    @employees = paginate_scope
  end

  private

  def scope
    Employee
  end

  def default_order
    'created_at desc'
  end
end
