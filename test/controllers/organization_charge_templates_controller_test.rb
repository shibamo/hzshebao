require 'test_helper'

class OrganizationChargeTemplatesControllerTest < ActionController::TestCase
  setup do
    @organization_charge_template = organization_charge_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_charge_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_charge_template" do
    assert_difference('OrganizationChargeTemplate.count') do
      post :create, organization_charge_template: { comment: @organization_charge_template.comment, organization_customer_id: @organization_charge_template.organization_customer_id, price_bujiao: @organization_charge_template.price_bujiao, price_canbao: @organization_charge_template.price_canbao, price_geshui: @organization_charge_template.price_geshui, price_gongjijin_base: @organization_charge_template.price_gongjijin_base, price_gongjijin_geren: @organization_charge_template.price_gongjijin_geren, price_gongjijin_guanli: @organization_charge_template.price_gongjijin_guanli, price_gongjijin_qiye: @organization_charge_template.price_gongjijin_qiye, price_gongzi: @organization_charge_template.price_gongzi, price_qita_1: @organization_charge_template.price_qita_1, price_qita_2: @organization_charge_template.price_qita_2, price_qita_3: @organization_charge_template.price_qita_3, price_shebao_base: @organization_charge_template.price_shebao_base, price_shebao_geren: @organization_charge_template.price_shebao_geren, price_shebao_guanli: @organization_charge_template.price_shebao_guanli, price_shebao_qiye: @organization_charge_template.price_shebao_qiye, price_yujiao: @organization_charge_template.price_yujiao, user_id: @organization_charge_template.user_id }
    end

    assert_redirected_to organization_charge_template_path(assigns(:organization_charge_template))
  end

  test "should show organization_charge_template" do
    get :show, id: @organization_charge_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_charge_template
    assert_response :success
  end

  test "should update organization_charge_template" do
    patch :update, id: @organization_charge_template, organization_charge_template: { comment: @organization_charge_template.comment, organization_customer_id: @organization_charge_template.organization_customer_id, price_bujiao: @organization_charge_template.price_bujiao, price_canbao: @organization_charge_template.price_canbao, price_geshui: @organization_charge_template.price_geshui, price_gongjijin_base: @organization_charge_template.price_gongjijin_base, price_gongjijin_geren: @organization_charge_template.price_gongjijin_geren, price_gongjijin_guanli: @organization_charge_template.price_gongjijin_guanli, price_gongjijin_qiye: @organization_charge_template.price_gongjijin_qiye, price_gongzi: @organization_charge_template.price_gongzi, price_qita_1: @organization_charge_template.price_qita_1, price_qita_2: @organization_charge_template.price_qita_2, price_qita_3: @organization_charge_template.price_qita_3, price_shebao_base: @organization_charge_template.price_shebao_base, price_shebao_geren: @organization_charge_template.price_shebao_geren, price_shebao_guanli: @organization_charge_template.price_shebao_guanli, price_shebao_qiye: @organization_charge_template.price_shebao_qiye, price_yujiao: @organization_charge_template.price_yujiao, user_id: @organization_charge_template.user_id }
    assert_redirected_to organization_charge_template_path(assigns(:organization_charge_template))
  end

  test "should destroy organization_charge_template" do
    assert_difference('OrganizationChargeTemplate.count', -1) do
      delete :destroy, id: @organization_charge_template
    end

    assert_redirected_to organization_charge_templates_path
  end
end
