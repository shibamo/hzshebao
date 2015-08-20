class AddWorkflowStateToSingleCustomers < ActiveRecord::Migration
  def change
    add_column :single_customers, :workflow_state, :string
  end
end
