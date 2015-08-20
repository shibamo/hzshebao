class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :single_customer_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :work

      t.timestamps null: false
    end
  end
end
