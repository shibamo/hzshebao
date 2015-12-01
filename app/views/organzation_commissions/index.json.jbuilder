json.array!(@organzation_commissions) do |organzation_commission|
  json.extract! organzation_commission, :id, :commission_no, :organization_charge_total_id, :user_id, :bonus_reference, :bonus, :approver_id, :financer_id, :workflow_state
  json.url organzation_commission_url(organzation_commission, format: :json)
end
