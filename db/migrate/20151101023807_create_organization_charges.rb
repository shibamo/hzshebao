class CreateOrganizationCharges < ActiveRecord::Migration
  def change
    create_table :organization_charges do |t|
      t.integer :organization_charge_total_id
      t.integer :organization_customer_id
      t.integer :organization_id
      t.integer :user_id
      t.decimal :price_shebao_base
      t.decimal :price_shebao_qiye
      t.decimal :price_shebao_geren
      t.decimal :price_canbao
      t.decimal :price_shebao_guanli
      t.decimal :price_gongjijin_base
      t.decimal :price_gongjijin_qiye
      t.decimal :price_gongjijin_geren
      t.decimal :price_gongjijin_guanli
      t.decimal :price_geshui
      t.decimal :price_qita_1
      t.decimal :price_qita_2
      t.decimal :price_qita_3
      t.decimal :price_bujiao
      t.decimal :price_yujiao
      t.decimal :price_gongzi
      t.date :start_date
      t.date :end_date
      t.string :comment

      t.timestamps null: false
    end
  end
end
