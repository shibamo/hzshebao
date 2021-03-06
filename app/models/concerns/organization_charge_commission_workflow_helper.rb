module OrganizationChargeCommissionWorkflowHelper
#为机构员工的社保和公积金服务提供工作流相关的公共功能集
  extend ActiveSupport::Concern

  included do
   #使用状态机管理提成单状态
    workflow do
      state :new do #新建
        event :finish_approve, :transitions_to => :approved
      end

      state :approved do #已审批
        event :finish_finance_check, :transitions_to => :finance_checkd
      end

      state :finance_checkd do #财务已复核
        event :finish_pay, :transitions_to => :payed #目前暂不实现
      end

      state :payed do #已支付 #目前暂不实现
      end
    end
    #状态名与中文名对应表
    WORKFLOW_STATE_NAMES = {new: :新建, approved: :已审批, finance_checkd: :财务已复核, payed: :已支付}
    #事件(操作)名与中文名对应表
    WORKFLOW_EVENT_NAMES = {finish_approve: :完成审批, finish_finance_check: :完成财务复核, finish_pay: :完成支付}

  end

end