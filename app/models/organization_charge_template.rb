class OrganizationChargeTemplate < ActiveRecord::Base
  include ModelHelper
  include OrganizationChargeCalculateHelper

  belongs_to :organization_customer #归属的机构员工
  belongs_to :organization #归属的机构
  belongs_to :user #创建记录的用户
  validates_presence_of :organization_customer_id, :user_id, message: "字段不能为空"

  scope :of_organization, ->(organization_ids) {where(organization_id: organization_ids)}

  def preset_attributes #未输入数字的数字框自动设置为0
    batch_set_nil_property_value 0.0,:price_shebao_base, :price_shebao_qiye, :price_shebao_geren, 
        :price_canbao, :price_shebao_guanli, :price_gongjijin_base, :price_gongjijin_qiye, 
        :price_gongjijin_geren, :price_gongjijin_guanli, :price_geshui, :price_qita_1, 
        :price_qita_2, :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi
  end

  before_validation :preset_attributes 


end
