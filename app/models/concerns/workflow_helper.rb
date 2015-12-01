module WorkflowHelper
  extend ActiveSupport::Concern

  included do
    scope :of_workflow_state, ->(workflow_state) {where(workflow_state: workflow_state)}
  end
end