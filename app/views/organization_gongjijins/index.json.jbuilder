json.array!(@organization_gongjijins) do |organization_gongjijin|
  json.extract! organization_gongjijin, :id, :organization_customer_id, :account_no, :workflow_state
  json.url organization_gongjijin_url(organization_gongjijin, format: :json)
end
