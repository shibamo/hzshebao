class CreateOrganizationCustomers < ActiveRecord::Migration
  def change
    create_table :organization_customers do |t|
      t.string :name
      t.integer :organzation_id
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
      t.integer :is_doc_for_shebao
      t.integer :is_doc_for_shigong
      t.integer :is_doc_for_shenggong
      t.integer :is_doc_for_butuichajia
      t.integer :is_doc_for_xufei
      t.integer :is_doc_for_qita
      t.integer :is_usage_zhengchang
      t.integer :is_usage_ruxue
      t.integer :is_usage_luohu
      t.integer :is_usage_shenyu
      t.integer :is_usage_yiliao
      t.integer :is_usage_gouche
      t.integer :is_usage_goufang
      t.integer :is_usage_daikuan
      t.string :creator
      t.string :creator_tel
      t.text :comment
      t.integer :user_id
      t.date :input_date
      t.string :document_no
      t.string :comment_for_qita
      t.string :workflow_state
      t.integer :is_valid
      t.date :valid_start
      t.date :valid_end

      t.timestamps null: false
    end
  end
end
