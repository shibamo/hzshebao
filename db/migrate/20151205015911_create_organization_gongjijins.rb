class CreateOrganizationGongjijins < ActiveRecord::Migration
  def change
    create_table :organization_gongjijins do |t|
      t.integer :organization_customer_id
      t.string :account_no
      t.string :workflow_state

      t.timestamps null: false
    end
  end
end
