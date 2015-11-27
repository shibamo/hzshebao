json.array!(@organization_charge_templates) do |organization_charge_template|
  json.extract! organization_charge_template, :id, :organization_customer_id, :user_id, :price_shebao_base, :price_shebao_qiye, :price_shebao_geren, :price_canbao, :price_shebao_guanli, :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :comment
  json.organization_customer_name organization_charge_template.organization_customer.name
end