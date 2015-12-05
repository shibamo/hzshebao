json.array!(@organization_shebaos) do |organization_shebao|
  json.extract! organization_shebao, :id, :organization_customer_id, :account_no, :workflow_state
  json.url organization_shebao_url(organization_shebao, format: :json)
end
