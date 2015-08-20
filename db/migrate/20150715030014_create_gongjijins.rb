class CreateGongjijins < ActiveRecord::Migration
  def change
    create_table :gongjijins do |t|
      t.integer :single_customer_id
      t.string :account_no
      t.string :workflow_state

      t.timestamps null: false
    end
  end
end
