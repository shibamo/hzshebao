class AddWorkflowStateToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :workflow_state, :string
  end
end
