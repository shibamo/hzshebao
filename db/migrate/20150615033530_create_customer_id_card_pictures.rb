class CreateCustomerIdCardPictures < ActiveRecord::Migration
  def change
    create_table :customer_id_card_pictures do |t|
      t.string :file_name
      t.binary :file_raw
      t.string :customer_type
      t.integer :customer_id
      t.string :content_type
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
