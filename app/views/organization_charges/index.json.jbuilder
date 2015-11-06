json.array!(@organization_charges) do |organization_charge|
  json.extract! organization_charge, :id, :organization_charge_total_id, :organization_customer_id, :organization_id, :user_id, :price_shebao_base, :price_shebao_qiye, :price_shebao_geren, :price_canbao, :price_shebao_guanli, :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :start_date, :end_date, :comment
  json.url organization_charge_url(organization_charge, format: :json)
end
