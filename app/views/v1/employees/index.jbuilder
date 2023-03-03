json.data do
  json.array! @employees, partial: 'employee', as: :employee
end

json.meta do
  json.partial! 'v1/shared/pagination', page_meta_data: @page_meta_data
end
