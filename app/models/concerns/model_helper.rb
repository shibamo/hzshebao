module ModelHelper
  extend ActiveSupport::Concern

  def batch_set_nil_property_value(value,*properties)
    properties.each do |property|
      self.send("#{property}=", value) if self.send("#{property}").nil?
    end
  end

  def organization_charge_money_total
    price_shebao_base + price_shebao_qiye + price_shebao_geren + price_canbao + price_shebao_guanli + price_gongjijin_base + 
    price_gongjijin_qiye + price_gongjijin_geren + price_gongjijin_guanli +   price_geshui + price_qita_1 + price_qita_2 + 
    price_qita_3+ price_bujiao+ price_yujiao+ price_gongzi 
  end
end