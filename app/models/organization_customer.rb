class OrganizationCustomer < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow

  #生成档案编号的前缀,如"B20150612", 其中 1位:固定为"B",2-9位:日期数字
  def self.document_no_head_prefix
    "B"+ Date.today.to_formatted_s(format=:number)
  end

  belongs_to :user #归属的业务员
  belongs_to :organization #归属的机构

  has_many :customer_id_card_pictures, -> { where(customer_type: "机构客户") } ,foreign_key: :customer_id
  has_one :organization_charge_template #该机构员工客户对应的缴费模板
  has_many :organization_charges #该机构员工客户对应的缴费历史记录
  has_one :organization_shebao #该机构员工客户对应的社保服务
  has_one :organization_gongjijin #该机构员工客户对应的公积金服务

  validates_presence_of :organization_id, :name, :gender, :ethnic_name,:education,
            :birth, :id_no, :id_address, :hukou_type, :tel, :other_contact_person,
            :other_contact_call, :communication_address, :valid_start,
            message: "字段不能为空"

  validates_uniqueness_of :id_no, message: "身份证号已存在,不能重复创建已有客户"

  default_scope {order(created_at: :desc)}

  scope :created_at_today, -> { where("document_no like :document_no_head",
                            document_no_head:  document_no_head_prefix + "%") }
  scope :managed_by_users, ->(user_ids) {where(user_id: user_ids).order(:user_id)}

  scope :order_by_users, ->{unscoped.order(:user_id)}

  scope :by_partial_name, ->(partial_name) {where("name like ?", "%#{partial_name}%")}

  scope :by_organization_ids, ->(organization_ids) {where(organization_id: organization_ids).order(:organization_id)}
  
  paginates_per 20             #每页显示n条数据


  #生成档案编号,如"B201506120001", 其中 1位:固定为"B",2-9位:日期数字,最后四位为流水号
  #未来可考虑重构与SingleCustomer的类似实现合并
  before_create do
    if self.document_no.length == 0
      serial_no = (OrganizationCustomer.created_at_today.count + 1).to_s
      self.document_no = OrganizationCustomer.document_no_head_prefix + "0"*(4-serial_no.length) + serial_no
    end
  end

  def charge_template_exist? #是否已有收费模板
    return !self.organization_charge_template.nil?
  end

  #使用状态机管理状态
  workflow do
    state :new do #新建
      event :finish_check, :transitions_to => :serving
      event :finish_apply_stop, :transitions_to => :stopped #允许直接停止服务
    end

    state :serving do #服务中
      event :finish_apply_stop, :transitions_to => :stopped
    end

    state :stopped do #已停止服务
      event :finish_apply_restart, :transitions_to => :serving
    end
  end
  #状态名与中文名对应表
  WORKFLOW_STATE_NAMES = {new: :新建, serving: :服务中, stopped: :已停止服务}
  #事件(操作)名与中文名对应表
  WORKFLOW_EVENT_NAMES = {finish_check: :复核完成, finish_apply_stop: :停止服务, 
                          finish_apply_restart: :重新开通服务}
end
