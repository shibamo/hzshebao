class OrganizationChargeOther < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow
  include OrganizationChargeHelper
  include WorkflowHelper
  include ModelHelper

  belongs_to :organization
  belongs_to :user

  validates_presence_of :organization_id, :user_id, message: "字段不能为空"
  validates_presence_of :start_date, message: "服务开始日期字段不能为空"
  validates_presence_of :end_date, message: "服务结束日期字段不能为空"

  #分页显示列表
  paginates_per 100             #每页显示n条数据

  def price_receivable_total #机构其他收费金额总计,由需要收费的字段列表汇总
    price_fuwufei + price_canbao + price_chajia + price_gonghui + 
    price_qita_1 + price_qita_2 + price_qita_3 
  end
  def self.price_receivable_list #需要收费的字段列表
    ["price_fuwufei","price_canbao","price_chajia","price_gonghui", 
    "price_qita_1","price_qita_2","price_qita_3"]
  end
end
