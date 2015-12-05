class CreateOrganizationShebaos < ActiveRecord::Migration
  def change
    create_table :organization_shebaos do |t|
      t.integer :organization_customer_id
      t.string :account_no
      t.string :workflow_state

      t.timestamps null: false
    end
  end
end
