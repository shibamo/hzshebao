class CreateSingleCustomers < ActiveRecord::Migration
  def change
    create_table :single_customers do |t|
      t.string :name
      t.integer :gender
      t.string :ethnic_name
      t.date :birth
      t.string :id_no
      t.string :id_address
      t.integer :hukou_type
      t.string :education
      t.string :tel
      t.string :other_contact_person
      t.string :other_contact_call
      t.string :qq
      t.string :wechat
      t.string :email
      t.string :communication_address
      t.boolean :is_doc_for_shebao
      t.boolean :is_doc_for_shigong
      t.boolean :is_doc_for_shenggong
      t.boolean :is_doc_for_butuichajia
      t.boolean :is_doc_for_xufei
      t.boolean :is_doc_for_qita
      t.boolean :is_usage_zhengchang
      t.boolean :is_usage_ruxue
      t.boolean :is_usage_luohu
      t.boolean :is_usage_shenyu
      t.boolean :is_usage_yiliao
      t.boolean :is_usage_gouche
      t.boolean :is_usage_goufang
      t.boolean :is_usage_daikuan
      t.string :creator
      t.string :creator_tel
      t.text :comment
      t.integer :user_id
      t.date :input_date
      t.string :document_no

      t.timestamps null: false
    end
  end
end
