class AddIndexToCustomerIdCardPictures < ActiveRecord::Migration
  def change
    add_index :customer_id_card_pictures,[:customer_id], name: :idx_query_customeridcardpicture
  end
end
