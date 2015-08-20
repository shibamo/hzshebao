json.array!(@charges) do |charge|
  json.extract! charge, :id, :single_customer_id, :user_id, :charge_type, :money_arrival_state, :money_arrival_time, :is_lead_checked, :lead_check_time, :shenbao_state, :shenbao_time, :start_date, :end_date, :price_shebao, :months_shebao, :price_gongjijin, :months_gongjijin, :price_fuwufei, :months_fuwufei, :price_cailiaofei, :months_cailiaofei, :price_bujiao, :months_bujiao
  json.url charge_url(charge, format: :json)
end
