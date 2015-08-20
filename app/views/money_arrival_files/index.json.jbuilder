json.array!(@money_arrival_files) do |money_arrival_file|
  json.extract! money_arrival_file, :id, :filename, :file_raw, :business_type, :main_object_id, :content_type, :user_id
  json.url money_arrival_file_url(money_arrival_file, format: :json)
end
