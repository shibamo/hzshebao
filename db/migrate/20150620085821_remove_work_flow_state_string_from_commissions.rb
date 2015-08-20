class RemoveWorkFlowStateStringFromCommissions < ActiveRecord::Migration
  def change
    remove_column :commissions, :workflow_state_string, :string
  end
end
