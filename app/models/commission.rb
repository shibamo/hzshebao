class Commission < ActiveRecord::Base
	include Workflow
	include ChinesifyWorkflow

	belongs_to :charge
  belongs_to :user

	validates_presence_of :bonus_reference, :bonus, message: "金额字段不能为空"

  default_scope {order(created_at: :desc)}
  
  scope :managed_by_users, ->(user_ids) {where(user_id: user_ids)}

  paginates_per 20             #每页显示n条数据


	#使用状态机管理缴费单状态
  workflow do
  	state :new do #新建
  		event :finish_approve, :transitions_to => :approved
  	end

  	state :approved do #已审批
  		event :finish_finance_check, :transitions_to => :finance_checkd
  	end

  	state :finance_checkd do #财务已复核
  		event :finish_pay, :transitions_to => :payed
  	end

  	state :payed do #已支付
  	end
  end
  #状态名与中文名对应表
  WORKFLOW_STATE_NAMES = {new: :新建, approved: :已审批, finance_checkd: :财务已复核, payed: :已支付}
  #事件(操作)名与中文名对应表
  WORKFLOW_EVENT_NAMES = {finish_approve: :完成审批, finish_finance_check: :完成财务复核, finish_pay: :完成支付}

  def finish_approve(approver_id)
    self.approver_id = approver_id
    self.save
  end

  def finish_finance_check(financer_id)
    self.financer_id = financer_id
    self.save
  end    

end
