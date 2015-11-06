require 'test_helper'

class OrganizationChargeTotalsControllerTest < ActionController::TestCase
  setup do
    @organization_charge_total = organization_charge_totals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_charge_totals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_charge_total" do
    assert_difference('OrganizationChargeTotal.count') do
      post :create, organization_charge_total: { comment: @organization_charge_total.comment, end_date: @organization_charge_total.end_date, money_arrival_date: @organization_charge_total.money_arrival_date, money_check_date: @organization_charge_total.money_check_date, organization_id: @organization_charge_total.organization_id, price_bujiao: @organization_charge_total.price_bujiao, price_canbao: @organization_charge_total.price_canbao, price_geshui: @organization_charge_total.price_geshui, price_gongjijin_base: @organization_charge_total.price_gongjijin_base, price_gongjijin_geren: @organization_charge_total.price_gongjijin_geren, price_gongjijin_guanli: @organization_charge_total.price_gongjijin_guanli, price_gongjijin_qiye: @organization_charge_total.price_gongjijin_qiye, price_gongzi: @organization_charge_total.price_gongzi, price_qita_1: @organization_charge_total.price_qita_1, price_qita_2: @organization_charge_total.price_qita_2, price_qita_3: @organization_charge_total.price_qita_3, price_shebao_base: @organization_charge_total.price_shebao_base, price_shebao_geren: @organization_charge_total.price_shebao_geren, price_shebao_guanli: @organization_charge_total.price_shebao_guanli, price_shebao_qiye: @organization_charge_total.price_shebao_qiye, price_yujiao: @organization_charge_total.price_yujiao, start_date: @organization_charge_total.start_date, user_id: @organization_charge_total.user_id, workflow_state: @organization_charge_total.workflow_state }
    end

    assert_redirected_to organization_charge_total_path(assigns(:organization_charge_total))
  end

  test "should show organization_charge_total" do
    get :show, id: @organization_charge_total
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_charge_total
    assert_response :success
  end

  test "should update organization_charge_total" do
    patch :update, id: @organization_charge_total, organization_charge_total: { comment: @organization_charge_total.comment, end_date: @organization_charge_total.end_date, money_arrival_date: @organization_charge_total.money_arrival_date, money_check_date: @organization_charge_total.money_check_date, organization_id: @organization_charge_total.organization_id, price_bujiao: @organization_charge_total.price_bujiao, price_canbao: @organization_charge_total.price_canbao, price_geshui: @organization_charge_total.price_geshui, price_gongjijin_base: @organization_charge_total.price_gongjijin_base, price_gongjijin_geren: @organization_charge_total.price_gongjijin_geren, price_gongjijin_guanli: @organization_charge_total.price_gongjijin_guanli, price_gongjijin_qiye: @organization_charge_total.price_gongjijin_qiye, price_gongzi: @organization_charge_total.price_gongzi, price_qita_1: @organization_charge_total.price_qita_1, price_qita_2: @organization_charge_total.price_qita_2, price_qita_3: @organization_charge_total.price_qita_3, price_shebao_base: @organization_charge_total.price_shebao_base, price_shebao_geren: @organization_charge_total.price_shebao_geren, price_shebao_guanli: @organization_charge_total.price_shebao_guanli, price_shebao_qiye: @organization_charge_total.price_shebao_qiye, price_yujiao: @organization_charge_total.price_yujiao, start_date: @organization_charge_total.start_date, user_id: @organization_charge_total.user_id, workflow_state: @organization_charge_total.workflow_state }
    assert_redirected_to organization_charge_total_path(assigns(:organization_charge_total))
  end

  test "should destroy organization_charge_total" do
    assert_difference('OrganizationChargeTotal.count', -1) do
      delete :destroy, id: @organization_charge_total
    end

    assert_redirected_to organization_charge_totals_path
  end
end
