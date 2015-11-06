require 'test_helper'

class OrganizationCustomersControllerTest < ActionController::TestCase
  setup do
    @organization_customer = organization_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_customer" do
    assert_difference('OrganizationCustomer.count') do
      post :create, organization_customer: { birth: @organization_customer.birth, comment: @organization_customer.comment, comment_for_qita: @organization_customer.comment_for_qita, communication_address: @organization_customer.communication_address, creator: @organization_customer.creator, creator_tel: @organization_customer.creator_tel, document_no: @organization_customer.document_no, education: @organization_customer.education, email: @organization_customer.email, ethnic_name: @organization_customer.ethnic_name, gender: @organization_customer.gender, hukou_type: @organization_customer.hukou_type, id_address: @organization_customer.id_address, id_no: @organization_customer.id_no, input_date: @organization_customer.input_date, is_doc_for_butuichajia: @organization_customer.is_doc_for_butuichajia, is_doc_for_qita: @organization_customer.is_doc_for_qita, is_doc_for_shebao: @organization_customer.is_doc_for_shebao, is_doc_for_shenggong: @organization_customer.is_doc_for_shenggong, is_doc_for_shigong: @organization_customer.is_doc_for_shigong, is_doc_for_xufei: @organization_customer.is_doc_for_xufei, is_usage_daikuan: @organization_customer.is_usage_daikuan, is_usage_gouche: @organization_customer.is_usage_gouche, is_usage_goufang: @organization_customer.is_usage_goufang, is_usage_luohu: @organization_customer.is_usage_luohu, is_usage_ruxue: @organization_customer.is_usage_ruxue, is_usage_shenyu: @organization_customer.is_usage_shenyu, is_usage_yiliao: @organization_customer.is_usage_yiliao, is_usage_zhengchang: @organization_customer.is_usage_zhengchang, is_valid: @organization_customer.is_valid, name: @organization_customer.name, organzation_id: @organization_customer.organzation_id, other_contact_call: @organization_customer.other_contact_call, other_contact_person: @organization_customer.other_contact_person, qq: @organization_customer.qq, tel: @organization_customer.tel, user_id: @organization_customer.user_id, valid_end: @organization_customer.valid_end, valid_start: @organization_customer.valid_start, wechat: @organization_customer.wechat, workflow_state: @organization_customer.workflow_state }
    end

    assert_redirected_to organization_customer_path(assigns(:organization_customer))
  end

  test "should show organization_customer" do
    get :show, id: @organization_customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_customer
    assert_response :success
  end

  test "should update organization_customer" do
    patch :update, id: @organization_customer, organization_customer: { birth: @organization_customer.birth, comment: @organization_customer.comment, comment_for_qita: @organization_customer.comment_for_qita, communication_address: @organization_customer.communication_address, creator: @organization_customer.creator, creator_tel: @organization_customer.creator_tel, document_no: @organization_customer.document_no, education: @organization_customer.education, email: @organization_customer.email, ethnic_name: @organization_customer.ethnic_name, gender: @organization_customer.gender, hukou_type: @organization_customer.hukou_type, id_address: @organization_customer.id_address, id_no: @organization_customer.id_no, input_date: @organization_customer.input_date, is_doc_for_butuichajia: @organization_customer.is_doc_for_butuichajia, is_doc_for_qita: @organization_customer.is_doc_for_qita, is_doc_for_shebao: @organization_customer.is_doc_for_shebao, is_doc_for_shenggong: @organization_customer.is_doc_for_shenggong, is_doc_for_shigong: @organization_customer.is_doc_for_shigong, is_doc_for_xufei: @organization_customer.is_doc_for_xufei, is_usage_daikuan: @organization_customer.is_usage_daikuan, is_usage_gouche: @organization_customer.is_usage_gouche, is_usage_goufang: @organization_customer.is_usage_goufang, is_usage_luohu: @organization_customer.is_usage_luohu, is_usage_ruxue: @organization_customer.is_usage_ruxue, is_usage_shenyu: @organization_customer.is_usage_shenyu, is_usage_yiliao: @organization_customer.is_usage_yiliao, is_usage_zhengchang: @organization_customer.is_usage_zhengchang, is_valid: @organization_customer.is_valid, name: @organization_customer.name, organzation_id: @organization_customer.organzation_id, other_contact_call: @organization_customer.other_contact_call, other_contact_person: @organization_customer.other_contact_person, qq: @organization_customer.qq, tel: @organization_customer.tel, user_id: @organization_customer.user_id, valid_end: @organization_customer.valid_end, valid_start: @organization_customer.valid_start, wechat: @organization_customer.wechat, workflow_state: @organization_customer.workflow_state }
    assert_redirected_to organization_customer_path(assigns(:organization_customer))
  end

  test "should destroy organization_customer" do
    assert_difference('OrganizationCustomer.count', -1) do
      delete :destroy, id: @organization_customer
    end

    assert_redirected_to organization_customers_path
  end
end
