class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.string :commission_no
      t.integer :charge_id
      t.integer :user_id
      t.decimal :bonus_reference
      t.decimal :bonus
      t.integer :approver_id
      t.integer :financer_id
      t.string :workflow_state_string

      t.timestamps null: false
    end
  end
end
