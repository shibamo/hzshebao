require 'test_helper'

class SingleCustomersControllerTest < ActionController::TestCase
  setup do
    @single_customer = single_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:single_customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create single_customer" do
    assert_difference('SingleCustomer.count') do
      post :create, single_customer: { birth: @single_customer.birth, comment: @single_customer.comment, communication_address: @single_customer.communication_address, creator: @single_customer.creator, creator_tel: @single_customer.creator_tel, document_no: @single_customer.document_no, education: @single_customer.education, email: @single_customer.email, ethnic_name: @single_customer.ethnic_name, gender: @single_customer.gender, hukou_type: @single_customer.hukou_type, id_address: @single_customer.id_address, id_no: @single_customer.id_no, input_date: @single_customer.input_date, is_doc_for_butuichajia: @single_customer.is_doc_for_butuichajia, is_doc_for_qita: @single_customer.is_doc_for_qita, is_doc_for_shebao: @single_customer.is_doc_for_shebao, is_doc_for_shenggong: @single_customer.is_doc_for_shenggong, is_doc_for_shigong: @single_customer.is_doc_for_shigong, is_doc_for_xufei: @single_customer.is_doc_for_xufei, is_usage_daikuan: @single_customer.is_usage_daikuan, is_usage_gouche: @single_customer.is_usage_gouche, is_usage_goufang: @single_customer.is_usage_goufang, is_usage_luohu: @single_customer.is_usage_luohu, is_usage_ruxue: @single_customer.is_usage_ruxue, is_usage_shenyu: @single_customer.is_usage_shenyu, is_usage_yiliao: @single_customer.is_usage_yiliao, is_usage_zhengchang: @single_customer.is_usage_zhengchang, name: @single_customer.name, other_contact_call: @single_customer.other_contact_call, other_contact_person: @single_customer.other_contact_person, qq: @single_customer.qq, tel: @single_customer.tel, user_id: @single_customer.user_id, wechat: @single_customer.wechat }
    end

    assert_redirected_to single_customer_path(assigns(:single_customer))
  end

  test "should show single_customer" do
    get :show, id: @single_customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @single_customer
    assert_response :success
  end

  test "should update single_customer" do
    patch :update, id: @single_customer, single_customer: { birth: @single_customer.birth, comment: @single_customer.comment, communication_address: @single_customer.communication_address, creator: @single_customer.creator, creator_tel: @single_customer.creator_tel, document_no: @single_customer.document_no, education: @single_customer.education, email: @single_customer.email, ethnic_name: @single_customer.ethnic_name, gender: @single_customer.gender, hukou_type: @single_customer.hukou_type, id_address: @single_customer.id_address, id_no: @single_customer.id_no, input_date: @single_customer.input_date, is_doc_for_butuichajia: @single_customer.is_doc_for_butuichajia, is_doc_for_qita: @single_customer.is_doc_for_qita, is_doc_for_shebao: @single_customer.is_doc_for_shebao, is_doc_for_shenggong: @single_customer.is_doc_for_shenggong, is_doc_for_shigong: @single_customer.is_doc_for_shigong, is_doc_for_xufei: @single_customer.is_doc_for_xufei, is_usage_daikuan: @single_customer.is_usage_daikuan, is_usage_gouche: @single_customer.is_usage_gouche, is_usage_goufang: @single_customer.is_usage_goufang, is_usage_luohu: @single_customer.is_usage_luohu, is_usage_ruxue: @single_customer.is_usage_ruxue, is_usage_shenyu: @single_customer.is_usage_shenyu, is_usage_yiliao: @single_customer.is_usage_yiliao, is_usage_zhengchang: @single_customer.is_usage_zhengchang, name: @single_customer.name, other_contact_call: @single_customer.other_contact_call, other_contact_person: @single_customer.other_contact_person, qq: @single_customer.qq, tel: @single_customer.tel, user_id: @single_customer.user_id, wechat: @single_customer.wechat }
    assert_redirected_to single_customer_path(assigns(:single_customer))
  end

  test "should destroy single_customer" do
    assert_difference('SingleCustomer.count', -1) do
      delete :destroy, id: @single_customer
    end

    assert_redirected_to single_customers_path
  end
end
