require 'test_helper'

class OrganzationCommissionsControllerTest < ActionController::TestCase
  setup do
    @organzation_commission = organzation_commissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organzation_commissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organzation_commission" do
    assert_difference('OrganzationCommission.count') do
      post :create, organzation_commission: { approver_id: @organzation_commission.approver_id, bonus: @organzation_commission.bonus, bonus_reference: @organzation_commission.bonus_reference, commission_no: @organzation_commission.commission_no, financer_id: @organzation_commission.financer_id, organization_charge_total_id: @organzation_commission.organization_charge_total_id, user_id: @organzation_commission.user_id, workflow_state: @organzation_commission.workflow_state }
    end

    assert_redirected_to organzation_commission_path(assigns(:organzation_commission))
  end

  test "should show organzation_commission" do
    get :show, id: @organzation_commission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organzation_commission
    assert_response :success
  end

  test "should update organzation_commission" do
    patch :update, id: @organzation_commission, organzation_commission: { approver_id: @organzation_commission.approver_id, bonus: @organzation_commission.bonus, bonus_reference: @organzation_commission.bonus_reference, commission_no: @organzation_commission.commission_no, financer_id: @organzation_commission.financer_id, organization_charge_total_id: @organzation_commission.organization_charge_total_id, user_id: @organzation_commission.user_id, workflow_state: @organzation_commission.workflow_state }
    assert_redirected_to organzation_commission_path(assigns(:organzation_commission))
  end

  test "should destroy organzation_commission" do
    assert_difference('OrganzationCommission.count', -1) do
      delete :destroy, id: @organzation_commission
    end

    assert_redirected_to organzation_commissions_path
  end
end
