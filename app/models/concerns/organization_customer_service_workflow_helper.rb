module OrganizationCustomerServiceWorkflowHelper
#为机构员工的社保和公积金服务提供工作流相关的公共功能集
  extend ActiveSupport::Concern
  include PagerHelper

  included do
    #使用状态机管理机构员工客户服务状态
    workflow do
      state :new do #新建
        event :finish_apply_start, :transitions_to => :serving
      end

      state :serving do #服务中
        event :finish_apply_stop, :transitions_to => :stopped
      end

      state :stopped do #已停
        event :finish_apply_restart, :transitions_to => :serving
      end
    end
    #状态名与中文名对应表
    WORKFLOW_STATE_NAMES = {new: :新建, serving: :服务中, stopped: :已停}
    #事件(操作)名与中文名对应表
    WORKFLOW_EVENT_NAMES = {finish_apply_start: :完成登记开通, finish_apply_stop: :完成登记停交, 
                            finish_apply_restart: :登记重新开通}
    
    def self.can_start #计算可以开通服务的客户列表
      self.with_new_state
    end
    
    def self.can_stop #计算可以停止服务的客户列表
      self.wrap_for_paging self, self.with_serving_state.
                            reject{|o| !o.organization_customer.valid_end} 
                            #只有离职日期不为空的机构员工客户才可能需要停止
    end

    def self.can_restart #计算可以重新开通服务的客户列表
      self.wrap_for_paging self,self.with_stopped_state.
                            reject{|o| o.organization_customer.valid_end} 
                            #只有离职为空的机构员工客户才可能需要重新开通 
    end
  end

end