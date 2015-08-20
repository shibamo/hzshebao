class Renewal < ActiveRecord::Base
	include Workflow
  include ChinesifyWorkflow

	belongs_to :single_customer
	belongs_to :user
	
	paginates_per 20             #每页显示n条数据
	
	#使用状态机管理续费状态
  workflow do
  	state :new do #服务中-无需续费
  		event :need_renew, :transitions_to => :waiting
  	end

  	state :waiting do #服务中-等待续费
  		event :finish_renew, :transitions_to => :new
  		event :stop, :transitions_to => :stopped
  	end

  	state :stopped do #已停服-无需续费
  		event :finish_restart, :transitions_to => :new
  	end

  end
  #状态名与中文名对应表
  WORKFLOW_STATE_NAMES = { new: "服务中-无需续费", waiting: "服务中-等待续费", stopped: "已停服无需续费"}
  #事件(操作)名与中文名对应表
  WORKFLOW_EVENT_NAMES = {need_renew: :需要续费, finish_renew: :续费完成, stop: :停止服务, finish_restart: :重新开通}
end
