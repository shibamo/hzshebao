json.extract! @organization_charge_total, :id, :comment, :start_date, :end_date

json.organization_charges @organization_charge_total.organization_charges do |oc| 
  json.id oc.id
  json.organization_customer_id oc.organization_customer_id
  json.user_id oc.user_id
  json.price_shebao_base oc.price_shebao_base.round(2)
  json.price_shebao_qiye oc.price_shebao_qiye.round(2)
  json.price_shebao_geren oc.price_shebao_geren.round(2)
  json.price_canbao oc.price_canbao.round(2)
  json.price_shebao_guanli oc.price_shebao_guanli.round(2)
  json.price_gongjijin_base oc.price_gongjijin_base.round(2)
  json.price_gongjijin_qiye oc.price_gongjijin_qiye.round(2)
  json.price_gongjijin_geren oc.price_gongjijin_geren.round(2)
  json.price_gongjijin_guanli oc.price_gongjijin_guanli.round(2)
  json.price_geshui oc.price_geshui.round(2)
  json.price_qita_1 oc.price_qita_1.round(2)
  json.price_qita_2 oc.price_qita_2.round(2)
  json.price_qita_3 oc.price_qita_3.round(2)
  json.price_bujiao oc.price_bujiao.round(2)
  json.price_yujiao oc.price_yujiao.round(2)
  json.price_gongzi oc.price_gongzi.round(2)
  json.comment oc.comment
  json.organization_customer_name oc.organization_customer.name
end

