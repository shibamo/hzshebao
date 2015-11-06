require 'test_helper'

class OrganizationChargesControllerTest < ActionController::TestCase
  setup do
    @organization_charge = organization_charges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_charges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_charge" do
    assert_difference('OrganizationCharge.count') do
      post :create, organization_charge: { comment: @organization_charge.comment, end_date: @organization_charge.end_date, organization_charge_total_id: @organization_charge.organization_charge_total_id, organization_customer_id: @organization_charge.organization_customer_id, organization_id: @organization_charge.organization_id, price_bujiao: @organization_charge.price_bujiao, price_canbao: @organization_charge.price_canbao, price_geshui: @organization_charge.price_geshui, price_gongjijin_base: @organization_charge.price_gongjijin_base, price_gongjijin_geren: @organization_charge.price_gongjijin_geren, price_gongjijin_guanli: @organization_charge.price_gongjijin_guanli, price_gongjijin_qiye: @organization_charge.price_gongjijin_qiye, price_gongzi: @organization_charge.price_gongzi, price_qita_1: @organization_charge.price_qita_1, price_qita_2: @organization_charge.price_qita_2, price_qita_3: @organization_charge.price_qita_3, price_shebao_base: @organization_charge.price_shebao_base, price_shebao_geren: @organization_charge.price_shebao_geren, price_shebao_guanli: @organization_charge.price_shebao_guanli, price_shebao_qiye: @organization_charge.price_shebao_qiye, price_yujiao: @organization_charge.price_yujiao, start_date: @organization_charge.start_date, user_id: @organization_charge.user_id }
    end

    assert_redirected_to organization_charge_path(assigns(:organization_charge))
  end

  test "should show organization_charge" do
    get :show, id: @organization_charge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_charge
    assert_response :success
  end

  test "should update organization_charge" do
    patch :update, id: @organization_charge, organization_charge: { comment: @organization_charge.comment, end_date: @organization_charge.end_date, organization_charge_total_id: @organization_charge.organization_charge_total_id, organization_customer_id: @organization_charge.organization_customer_id, organization_id: @organization_charge.organization_id, price_bujiao: @organization_charge.price_bujiao, price_canbao: @organization_charge.price_canbao, price_geshui: @organization_charge.price_geshui, price_gongjijin_base: @organization_charge.price_gongjijin_base, price_gongjijin_geren: @organization_charge.price_gongjijin_geren, price_gongjijin_guanli: @organization_charge.price_gongjijin_guanli, price_gongjijin_qiye: @organization_charge.price_gongjijin_qiye, price_gongzi: @organization_charge.price_gongzi, price_qita_1: @organization_charge.price_qita_1, price_qita_2: @organization_charge.price_qita_2, price_qita_3: @organization_charge.price_qita_3, price_shebao_base: @organization_charge.price_shebao_base, price_shebao_geren: @organization_charge.price_shebao_geren, price_shebao_guanli: @organization_charge.price_shebao_guanli, price_shebao_qiye: @organization_charge.price_shebao_qiye, price_yujiao: @organization_charge.price_yujiao, start_date: @organization_charge.start_date, user_id: @organization_charge.user_id }
    assert_redirected_to organization_charge_path(assigns(:organization_charge))
  end

  test "should destroy organization_charge" do
    assert_difference('OrganizationCharge.count', -1) do
      delete :destroy, id: @organization_charge
    end

    assert_redirected_to organization_charges_path
  end
end
