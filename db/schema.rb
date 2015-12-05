# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151205015911) do

  create_table "administrators", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "last_login_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "single_customer_id"
    t.integer  "user_id"
    t.string   "charge_type"
    t.string   "money_arrival_state"
    t.datetime "money_arrival_time"
    t.boolean  "is_lead_checked"
    t.datetime "lead_check_time"
    t.string   "shenbao_state"
    t.datetime "shenbao_time"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "price_shebao",          default: 0.0
    t.integer  "months_shebao",         default: 0
    t.decimal  "price_gongjijin",       default: 0.0
    t.integer  "months_gongjijin",      default: 0
    t.decimal  "price_fuwufei",         default: 0.0
    t.integer  "months_fuwufei",        default: 0
    t.decimal  "price_cailiaofei",      default: 0.0
    t.integer  "months_cailiaofei",     default: 0
    t.decimal  "price_bujiao",          default: 0.0
    t.integer  "months_bujiao",         default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "comment"
    t.string   "document_no"
    t.string   "workflow_state"
    t.date     "money_arrival_date"
    t.date     "start_date_shebao"
    t.date     "end_date_shebao"
    t.date     "start_date_gongjijin"
    t.date     "end_date_gongjijin"
    t.date     "start_date_fuwufei"
    t.date     "end_date_fuwufei"
    t.date     "start_date_cailiaofei"
    t.date     "end_date_cailiaofei"
    t.date     "start_date_bujiao"
    t.date     "end_date_bujiao"
    t.date     "money_check_date"
    t.decimal  "price_geshui",          default: 0.0
    t.integer  "months_geshui",         default: 0
    t.date     "start_date_geshui"
    t.date     "end_date_geshui"
    t.decimal  "price_chajia",          default: 0.0
    t.integer  "months_chajia",         default: 0
    t.date     "start_date_chajia"
    t.date     "end_date_chajia"
  end

  create_table "commissions", force: :cascade do |t|
    t.string   "commission_no"
    t.integer  "charge_id"
    t.integer  "user_id"
    t.decimal  "bonus_reference"
    t.decimal  "bonus"
    t.integer  "approver_id"
    t.integer  "financer_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "workflow_state"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "single_customer_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "work"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "salary"
    t.string   "location"
  end

  create_table "customer_id_card_pictures", force: :cascade do |t|
    t.string   "file_name"
    t.binary   "file_raw"
    t.string   "customer_type"
    t.integer  "customer_id"
    t.string   "content_type"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "customer_id_card_pictures", ["customer_id"], name: "idx_query_customeridcardpicture"

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_valid"
    t.integer  "display_order"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "functions", force: :cascade do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "gongjijins", force: :cascade do |t|
    t.integer  "single_customer_id"
    t.string   "account_no"
    t.string   "workflow_state"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "money_arrival_files", force: :cascade do |t|
    t.binary   "file_raw"
    t.string   "business_type"
    t.integer  "main_object_id"
    t.string   "content_type"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "file_name"
    t.string   "extra_data"
    t.string   "business_action"
  end

  add_index "money_arrival_files", ["business_type", "main_object_id", "extra_data", "business_action"], name: "idx_query_1"

  create_table "organization_charge_templates", force: :cascade do |t|
    t.integer  "organization_customer_id"
    t.integer  "user_id"
    t.decimal  "price_shebao_base"
    t.decimal  "price_shebao_qiye"
    t.decimal  "price_shebao_geren"
    t.decimal  "price_canbao"
    t.decimal  "price_shebao_guanli"
    t.decimal  "price_gongjijin_base"
    t.decimal  "price_gongjijin_qiye"
    t.decimal  "price_gongjijin_geren"
    t.decimal  "price_gongjijin_guanli"
    t.decimal  "price_geshui"
    t.decimal  "price_qita_1"
    t.decimal  "price_qita_2"
    t.decimal  "price_qita_3"
    t.decimal  "price_bujiao"
    t.decimal  "price_yujiao"
    t.decimal  "price_gongzi"
    t.string   "comment"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "organization_id"
  end

  create_table "organization_charge_totals", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.decimal  "price_shebao_base"
    t.decimal  "price_shebao_qiye"
    t.decimal  "price_shebao_geren"
    t.decimal  "price_canbao"
    t.decimal  "price_shebao_guanli"
    t.decimal  "price_gongjijin_base"
    t.decimal  "price_gongjijin_qiye"
    t.decimal  "price_gongjijin_geren"
    t.decimal  "price_gongjijin_guanli"
    t.decimal  "price_geshui"
    t.decimal  "price_qita_1"
    t.decimal  "price_qita_2"
    t.decimal  "price_qita_3"
    t.decimal  "price_bujiao"
    t.decimal  "price_yujiao"
    t.decimal  "price_gongzi"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "comment"
    t.date     "money_arrival_date"
    t.date     "money_check_date"
    t.string   "workflow_state"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "organization_charges", force: :cascade do |t|
    t.integer  "organization_charge_total_id"
    t.integer  "organization_customer_id"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.decimal  "price_shebao_base"
    t.decimal  "price_shebao_qiye"
    t.decimal  "price_shebao_geren"
    t.decimal  "price_canbao"
    t.decimal  "price_shebao_guanli"
    t.decimal  "price_gongjijin_base"
    t.decimal  "price_gongjijin_qiye"
    t.decimal  "price_gongjijin_geren"
    t.decimal  "price_gongjijin_guanli"
    t.decimal  "price_geshui"
    t.decimal  "price_qita_1"
    t.decimal  "price_qita_2"
    t.decimal  "price_qita_3"
    t.decimal  "price_bujiao"
    t.decimal  "price_yujiao"
    t.decimal  "price_gongzi"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "comment"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "organization_customers", force: :cascade do |t|
    t.string   "name"
    t.integer  "gender"
    t.string   "ethnic_name"
    t.date     "birth"
    t.string   "id_no"
    t.string   "id_address"
    t.integer  "hukou_type"
    t.string   "education"
    t.string   "tel"
    t.string   "other_contact_person"
    t.string   "other_contact_call"
    t.string   "qq"
    t.string   "wechat"
    t.string   "email"
    t.string   "communication_address"
    t.integer  "is_doc_for_shebao"
    t.integer  "is_doc_for_shigong"
    t.integer  "is_doc_for_shenggong"
    t.integer  "is_doc_for_butuichajia"
    t.integer  "is_doc_for_xufei"
    t.integer  "is_doc_for_qita"
    t.integer  "is_usage_zhengchang"
    t.integer  "is_usage_ruxue"
    t.integer  "is_usage_luohu"
    t.integer  "is_usage_shenyu"
    t.integer  "is_usage_yiliao"
    t.integer  "is_usage_gouche"
    t.integer  "is_usage_goufang"
    t.integer  "is_usage_daikuan"
    t.string   "creator"
    t.string   "creator_tel"
    t.text     "comment"
    t.integer  "user_id"
    t.date     "input_date"
    t.string   "document_no"
    t.string   "comment_for_qita"
    t.string   "workflow_state"
    t.integer  "is_valid"
    t.date     "valid_start"
    t.date     "valid_end"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "organization_id"
  end

  create_table "organization_gongjijins", force: :cascade do |t|
    t.integer  "organization_customer_id"
    t.string   "account_no"
    t.string   "workflow_state"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "organization_shebaos", force: :cascade do |t|
    t.integer  "organization_customer_id"
    t.string   "account_no"
    t.string   "workflow_state"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "address"
    t.string   "person_in_charge"
    t.string   "email"
    t.string   "tel"
    t.string   "fax"
    t.string   "contact_person"
    t.string   "contact_tel"
    t.string   "contact_fax"
    t.date     "start_date"
    t.string   "workflow_state"
    t.integer  "user_id"
    t.integer  "is_valid"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "organzation_commissions", force: :cascade do |t|
    t.string   "commission_no"
    t.integer  "organization_charge_total_id"
    t.integer  "user_id"
    t.decimal  "bonus_reference"
    t.decimal  "bonus"
    t.integer  "approver_id"
    t.integer  "financer_id"
    t.string   "workflow_state"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "renewals", force: :cascade do |t|
    t.integer  "single_customer_id"
    t.integer  "user_id"
    t.string   "workflow_state"
    t.string   "comment"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "role_functions", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "function_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "role_users", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shebao_bases", force: :cascade do |t|
    t.decimal  "base"
    t.integer  "year"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "single_customers", force: :cascade do |t|
    t.string   "name"
    t.integer  "gender"
    t.string   "ethnic_name"
    t.date     "birth"
    t.string   "id_no"
    t.string   "id_address"
    t.integer  "hukou_type"
    t.string   "education"
    t.string   "tel"
    t.string   "other_contact_person"
    t.string   "other_contact_call"
    t.string   "qq"
    t.string   "wechat"
    t.string   "email"
    t.string   "communication_address"
    t.boolean  "is_doc_for_shebao"
    t.boolean  "is_doc_for_shigong"
    t.boolean  "is_doc_for_shenggong"
    t.boolean  "is_doc_for_butuichajia"
    t.boolean  "is_doc_for_xufei"
    t.boolean  "is_doc_for_qita"
    t.boolean  "is_usage_zhengchang"
    t.boolean  "is_usage_ruxue"
    t.boolean  "is_usage_luohu"
    t.boolean  "is_usage_shenyu"
    t.boolean  "is_usage_yiliao"
    t.boolean  "is_usage_gouche"
    t.boolean  "is_usage_goufang"
    t.boolean  "is_usage_daikuan"
    t.string   "creator"
    t.string   "creator_tel"
    t.text     "comment"
    t.integer  "user_id"
    t.date     "input_date"
    t.string   "document_no"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "workflow_state"
    t.string   "comment_for_qita"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "logon_name"
    t.string   "password_digest"
    t.boolean  "is_valid"
    t.boolean  "is_leader"
    t.boolean  "is_admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "department_id"
  end

end
