class OrganizationShebao < ActiveRecord::Base
  include Workflow
  include ChinesifyWorkflow
  include OrganizationCustomerServiceWorkflowHelper
  
  belongs_to :organization_customer

  default_scope {order(created_at: :desc)}

  paginates_per 20             #每页显示n条数据
end
