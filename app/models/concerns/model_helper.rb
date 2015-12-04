module ModelHelper
  extend ActiveSupport::Concern

  def batch_set_nil_property_value(value,*properties)
    properties.each do |property|
      self.send("#{property}=", value) if self.send("#{property}").nil?
    end
  end

  def price_receivable_total #机构总收费金额,由需要收费的字段列表汇总,未来需要改为读取price_receivable_list的模式
    price_shebao_qiye + price_shebao_geren + price_canbao + price_shebao_guanli + price_gongjijin_qiye + 
    price_gongjijin_geren + price_gongjijin_guanli + price_geshui + price_qita_1 + price_qita_2 + 
    price_qita_3 + price_bujiao + price_yujiao + price_gongzi
  end
end