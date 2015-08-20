json.array!(@customer_id_card_pictures) do |customer_id_card_picture|
  json.extract! customer_id_card_picture, :id, :file_name, :file_raw, :customer_type, :customer_id, :content_type, :user_id
  json.url customer_id_card_picture_url(customer_id_card_picture, format: :json)
end
