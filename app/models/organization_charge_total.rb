class OrganizationChargeTotal < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow
  include ModelHelper
  include OrganizationChargeCalculateHelper
  include OrganizationChargeHelper
  include WorkflowHelper

  has_many :organization_charges, autosave: true
  belongs_to :organization
  belongs_to :user

  validates_presence_of :organization_id, :user_id,:start_date,:end_date, message: "字段不能为空"

  default_scope {order(created_at: :desc)}

  #分页显示列表
  paginates_per 100             #每页显示n条数据

  def self.price_receivable_list #需要收费的字段列表
    ["price_shebao_qiye","price_shebao_geren","price_canbao","price_shebao_guanli","price_gongjijin_qiye", 
    "price_gongjijin_geren","price_gongjijin_guanli","price_geshui","price_qita_1","price_qita_2",
    "price_qita_3","price_bujiao","price_yujiao","price_gongzi"]
  end
end
