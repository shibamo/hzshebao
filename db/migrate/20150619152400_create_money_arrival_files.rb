class CreateMoneyArrivalFiles < ActiveRecord::Migration
  def change
    create_table :money_arrival_files do |t|
      t.string :filename
      t.binary :file_raw
      t.string :business_type
      t.integer :main_object_id
      t.string :content_type
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
