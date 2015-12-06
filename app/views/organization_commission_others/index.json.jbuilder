json.array!(@organization_commission_others) do |organization_commission_other|
  json.extract! organization_commission_other, :id, :organization_charge_other_id, :commission_no, :user_id, :bonus_reference, :bonus, :approver_id, :financer_id, :workflow_state
  json.url organization_commission_other_url(organization_commission_other, format: :json)
end
