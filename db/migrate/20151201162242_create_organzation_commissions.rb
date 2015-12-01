class CreateOrganzationCommissions < ActiveRecord::Migration
  def change
    create_table :organzation_commissions do |t|
      t.string :commission_no
      t.integer :organization_charge_total_id
      t.integer :user_id
      t.decimal :bonus_reference
      t.decimal :bonus
      t.integer :approver_id
      t.integer :financer_id
      t.string :workflow_state

      t.timestamps null: false
    end
  end
end
