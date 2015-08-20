class CreateRenewals < ActiveRecord::Migration
  def change
    create_table :renewals do |t|
      t.integer :single_customer_id
      t.integer :user_id
      t.string :workflow_state
      t.string :comment

      t.timestamps null: false
    end
  end
end
