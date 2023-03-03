# frozen_string_literal: true

class V1::EmployeesController < V1Controller
  include Paginable

  def index
    @employees = paginate_scope
    @page_meta_data = page_meta_data
  end

  private

  def scope
    Employee
  end

  def default_order
    'created_at desc'
  end

  def allowed_cursor_keys
    %i[created_at emp_id]
  end
end
