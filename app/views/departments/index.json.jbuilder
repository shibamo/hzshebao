json.array!(@departments) do |department|
  json.extract! department, :id, :name, :is_valid, :display_order, :user_id
  json.url department_url(department, format: :json)
end
