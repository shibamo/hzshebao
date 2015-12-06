require 'test_helper'

class OrganizationChargeOthersControllerTest < ActionController::TestCase
  setup do
    @organization_charge_other = organization_charge_others(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_charge_others)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_charge_other" do
    assert_difference('OrganizationChargeOther.count') do
      post :create, organization_charge_other: { comment: @organization_charge_other.comment, end_date: @organization_charge_other.end_date, money_arrival_date: @organization_charge_other.money_arrival_date, money_check_date: @organization_charge_other.money_check_date, organization_id: @organization_charge_other.organization_id, price_canbao: @organization_charge_other.price_canbao, price_chajia: @organization_charge_other.price_chajia, price_fuwufei: @organization_charge_other.price_fuwufei, price_gonghui: @organization_charge_other.price_gonghui, price_qita_1: @organization_charge_other.price_qita_1, price_qita_2: @organization_charge_other.price_qita_2, price_qita_3: @organization_charge_other.price_qita_3, start_date: @organization_charge_other.start_date, user_id: @organization_charge_other.user_id, workflow_state: @organization_charge_other.workflow_state }
    end

    assert_redirected_to organization_charge_other_path(assigns(:organization_charge_other))
  end

  test "should show organization_charge_other" do
    get :show, id: @organization_charge_other
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_charge_other
    assert_response :success
  end

  test "should update organization_charge_other" do
    patch :update, id: @organization_charge_other, organization_charge_other: { comment: @organization_charge_other.comment, end_date: @organization_charge_other.end_date, money_arrival_date: @organization_charge_other.money_arrival_date, money_check_date: @organization_charge_other.money_check_date, organization_id: @organization_charge_other.organization_id, price_canbao: @organization_charge_other.price_canbao, price_chajia: @organization_charge_other.price_chajia, price_fuwufei: @organization_charge_other.price_fuwufei, price_gonghui: @organization_charge_other.price_gonghui, price_qita_1: @organization_charge_other.price_qita_1, price_qita_2: @organization_charge_other.price_qita_2, price_qita_3: @organization_charge_other.price_qita_3, start_date: @organization_charge_other.start_date, user_id: @organization_charge_other.user_id, workflow_state: @organization_charge_other.workflow_state }
    assert_redirected_to organization_charge_other_path(assigns(:organization_charge_other))
  end

  test "should destroy organization_charge_other" do
    assert_difference('OrganizationChargeOther.count', -1) do
      delete :destroy, id: @organization_charge_other
    end

    assert_redirected_to organization_charge_others_path
  end
end
