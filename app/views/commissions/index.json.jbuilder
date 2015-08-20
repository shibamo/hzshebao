json.array!(@commissions) do |commission|
  json.extract! commission, :id, :commission_no, :charge_id, :user_id, :bonus_reference, :bonus, :approver_id, :financer_id, :workflow_state_string
  json.url commission_url(commission, format: :json)
end
