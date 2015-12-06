json.array!(@organization_charge_others) do |organization_charge_other|
  json.extract! organization_charge_other, :id, :organization_id, :user_id, :price_fuwufei, :price_canbao, :price_chajia, :price_gonghui, :price_qita_1, :price_qita_2, :price_qita_3, :start_date, :end_date, :comment, :money_arrival_date, :money_check_date, :workflow_state
  json.url organization_charge_other_url(organization_charge_other, format: :json)
end
