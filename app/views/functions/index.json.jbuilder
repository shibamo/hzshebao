json.array!(@functions) do |function|
  json.extract! function, :id, :name, :controller, :action, :description
  json.url function_url(function, format: :json)
end
