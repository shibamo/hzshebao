class Gongjijin < ActiveRecord::Base
	include Workflow
  include ChinesifyWorkflow

  belongs_to :single_customer

	scope :of_workflow_state, ->(workflow_state) {where(workflow_state: workflow_state)}

	default_scope {order(created_at: :desc)}

	paginates_per 20             #每页显示n条数据

	#使用状态机管理客户公积金状态
  workflow do
  	state :new do #新建
  		event :finish_apply_start, :transitions_to => :serving
  	end

  	state :serving do #公积金服务中
  		event :finish_apply_stop, :transitions_to => :stopped
  	end

  	state :stopped do #已停公积金
  		event :finish_apply_restart, :transitions_to => :serving
  	end
  end
  #状态名与中文名对应表
  WORKFLOW_STATE_NAMES = {new: :新建, serving: :公积金服务中, stopped: :已停公积金}
  #事件(操作)名与中文名对应表
  WORKFLOW_EVENT_NAMES = {finish_apply_start: :完成登记开通公积金, finish_apply_stop: :完成登记停交公积金, 
                          finish_apply_restart: :登记重新开通公积金}
  
  def self.need_start_gongjijin #计算需要开通公积金的客户列表
    #公积金处于"新建(new)"状态且公积金开始日期不为空
    ids = Gongjijin.with_new_state.collect {|t| t.id if t.single_customer.gongjijin_start_date}.delete_if{|t| t ==nil}
    Gongjijin.where(id: ids)
  end
  
  def self.need_renew #计算需要催交公积金续费的公积金状态列表
    #公积金处于"公积金服务中(serving)"状态且缴费不够覆盖支付到下月底
    ids1 = Gongjijin.with_serving_state.collect {|t| [t.id, t.single_customer.charges.maximum(:end_date_gongjijin)]}.
    																							delete_if { |a| a[1].nil? || a[1] > Date.today.next_month.end_of_month }.collect{|a| a[0]} 
    Gongjijin.where(id: ids1)
  end

end
