class OrganizationCommissionOther < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow
  include ModelHelper
  include OrganizationChargeCommissionWorkflowHelper
  include WorkflowHelper

  belongs_to :organization_charge_other
  belongs_to :user

  validates_presence_of :bonus_reference, :bonus, message: "金额字段不能为空"

  default_scope {order(created_at: :desc)}
  
  scope :managed_by_users, ->(user_ids) {where(user_id: user_ids)}

  paginates_per 20    #每页显示n条数据

  def finish_approve(approver_id)
    self.approver_id = approver_id
    self.save
  end

  def finish_finance_check(financer_id)
    self.financer_id = financer_id
    self.save
  end      
end
