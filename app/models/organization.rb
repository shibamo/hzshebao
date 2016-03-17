class Organization < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow

  belongs_to :user #归属的业务员
  has_many :organization_customers
  has_many :organization_charge_templates
  has_many :organization_charge_totals

  validates_presence_of :name, message: "机构名称-字段不能为空"
  validates_presence_of :abbr, message: "简称-字段不能为空"
  validates_presence_of :address, message: "地址-字段不能为空"
  validates_presence_of :person_in_charge, message: "负责人-字段不能为空"
  validates_presence_of :email, message: "电子邮件-字段不能为空"
  validates_presence_of :tel, message: "电话-字段不能为空"
  validates_presence_of :contact_person, message: "联系人-字段不能为空"
  validates_presence_of :contact_tel, message: "联系电话-字段不能为空"
  validates_presence_of :start_date, message: "服务开始日期-字段不能为空"

  validates_uniqueness_of :name, message: "机构名称已存在,不能重复创建"
  validates_uniqueness_of :abbr, message: "机构简称已存在,不能重复创建"

  default_scope {order(created_at: :desc)}
  scope :managed_by_users, ->(user_ids) {where(user_id: user_ids).order(:name)}
  scope :by_partial_name, ->(partial_name) {where("name like ?", "%#{partial_name}%")}
  scope :order_by_name, ->{order(:name)}

  paginates_per 50             #每页显示n条数据

  def any_customer_need_create_charge_template?
    self.organization_customers.any?{|oc| oc.organization_charge_template.nil?}
  end

  #使用状态机管理状态
  workflow do
    state :new do #新建
      event :finish_check, :transitions_to => :serving
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
