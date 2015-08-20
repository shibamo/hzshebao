json.array!(@contracts) do |contract|
  json.extract! contract, :id, :single_customer_id, :user_id, :start_date, :end_date, :work
  json.url contract_url(contract, format: :json)
end
