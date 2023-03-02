json.data do
  json.array! @employees, partial: 'employee', as: :employee
end
