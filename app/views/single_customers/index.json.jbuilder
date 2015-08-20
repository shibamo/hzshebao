json.array!(@single_customers) do |single_customer|
  json.extract! single_customer, :id, :name, :gender, :ethnic_name, :birth, :id_no, :id_address, :hukou_type, :education, :tel, :other_contact_person, :other_contact_call, :qq, :wechat, :email, :communication_address, :is_doc_for_shebao, :is_doc_for_shigong, :is_doc_for_shenggong, :is_doc_for_butuichajia, :is_doc_for_xufei, :is_doc_for_qita, :is_usage_zhengchang, :is_usage_ruxue, :is_usage_luohu, :is_usage_shenyu, :is_usage_yiliao, :is_usage_gouche, :is_usage_goufang, :is_usage_daikuan, :creator, :creator_tel, :comment, :user_id, :input_date, :document_no
  json.url single_customer_url(single_customer, format: :json)
end
