class OrganizationChargeTotal < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow
  include ModelHelper

  has_many :organization_charges, autosave: true
  belongs_to :organization
  #belongs_to :user

  validates_presence_of :organization_id, :user_id,:start_date,:end_date, message: "字段不能为空"

  scope :of_organization, ->(organization_ids) {where(organization_id: organization_ids).order(:start_date)}

  def price_receivable_total #总收费金额
    price_shebao_qiye + price_shebao_geren + price_canbao + price_shebao_guanli + price_gongjijin_qiye + 
    price_gongjijin_geren + price_gongjijin_guanli + price_geshui + price_qita_1 + price_qita_2 + 
    price_qita_3 + price_bujiao + price_yujiao + price_gongzi
  end

  #使用状态机管理缴费单状态
  workflow do
    state :new do #新建
      event :finish_money_check, :transitions_to => :money_arrived
    end

    state :money_arrived do #资金已到账
      event :finish_commission_form, :transitions_to => :commission_finished
    end

    state :commission_finished do #提成单已填写
      event :finish_leader_check, :transitions_to => :leader_check_finished
    end

    state :leader_check_finished do #领导已审核
    end
  end
  #状态名与中文名对应表
  WORKFLOW_STATE_NAMES = {new: :新建, money_arrived: :资金已到账, commission_finished: :提成单已填写, leader_check_finished: :领导已审核}
  #事件(操作)名与中文名对应表
  WORKFLOW_EVENT_NAMES = {finish_money_check: :完成资金核对, finish_commission_form: :完成提成单填写, finish_leader_check: :完成领导审核}


end
