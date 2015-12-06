class CreateOrganizationCommissionOthers < ActiveRecord::Migration
  def change
    create_table :organization_commission_others do |t|
      t.integer :organization_charge_other_id
      t.string :commission_no
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
