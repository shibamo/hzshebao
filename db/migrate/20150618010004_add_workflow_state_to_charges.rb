class AddWorkflowStateToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :workflow_state, :string
  end
end
