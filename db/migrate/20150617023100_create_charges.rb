class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :single_customer_id
      t.integer :user_id
      t.string :charge_type
      t.string :money_arrival_state
      t.datetime :money_arrival_time
      t.boolean :is_lead_checked
      t.datetime :lead_check_time
      t.string :shenbao_state
      t.datetime :shenbao_time
      t.date :start_date
      t.date :end_date
      t.decimal :price_shebao
      t.integer :months_shebao
      t.decimal :price_gongjijin
      t.integer :months_gongjijin
      t.decimal :price_fuwufei
      t.integer :months_fuwufei
      t.decimal :price_cailiaofei
      t.integer :months_cailiaofei
      t.decimal :price_bujiao
      t.integer :months_bujiao

      t.timestamps null: false
    end
  end
end
