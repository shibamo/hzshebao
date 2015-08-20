json.array!(@gongjijins) do |gongjijin|
  json.extract! gongjijin, :id, :single_customer_id, :account_no, :workflow_state
  json.url gongjijin_url(gongjijin, format: :json)
end
