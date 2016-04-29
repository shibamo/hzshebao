json.array!(@organization_charge_templates) do |o|
  json.extract! o, :id, :organization_customer_id, :user_id, :comment
  
  json.price_shebao_base o.price_shebao_base.round(2)
  json.price_shebao_qiye o.price_shebao_qiye.round(2)
  json.price_shebao_geren o.price_shebao_geren.round(2)
  json.price_canbao o.price_canbao.round(2)
  json.price_shebao_guanli o.price_shebao_guanli.round(2)
  json.price_gongjijin_base o.price_gongjijin_base.round(2)
  json.price_gongjijin_qiye o.price_gongjijin_qiye.round(2)
  json.price_gongjijin_geren o.price_gongjijin_geren.round(2)
  json.price_gongjijin_guanli o.price_gongjijin_guanli.round(2)
  json.price_geshui o.price_geshui.round(2)
  json.price_qita_1 o.price_qita_1.round(2)
  json.price_qita_2 o.price_qita_2.round(2)
  json.price_qita_3 o.price_qita_3.round(2)
  json.price_bujiao o.price_bujiao.round(2)
  json.price_yujiao o.price_yujiao.round(2)
  json.price_gongzi o.price_gongzi.round(2)

  json.organization_customer_name o.organization_customer.name
  json.valid_end o.organization_customer.valid_end
end
