json.array!(@renewals) do |renewal|
  json.extract! renewal, :id, :single_customer_id, :user_id, :workflow_state, :comment
  json.url renewal_url(renewal, format: :json)
end
