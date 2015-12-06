class CreateOrganizationChargeOthers < ActiveRecord::Migration
  def change
    create_table :organization_charge_others do |t|
      t.integer :organization_id
      t.integer :user_id
      t.decimal :price_fuwufei
      t.decimal :price_canbao
      t.decimal :price_chajia
      t.decimal :price_gonghui
      t.decimal :price_qita_1
      t.decimal :price_qita_2
      t.decimal :price_qita_3
      t.date :start_date
      t.date :end_date
      t.string :comment
      t.date :money_arrival_date
      t.date :money_check_date
      t.string :workflow_state

      t.timestamps null: false
    end
  end
end
