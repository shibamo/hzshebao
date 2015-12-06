require 'test_helper'

class OrganizationCommissionOthersControllerTest < ActionController::TestCase
  setup do
    @organization_commission_other = organization_commission_others(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_commission_others)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_commission_other" do
    assert_difference('OrganizationCommissionOther.count') do
      post :create, organization_commission_other: { approver_id: @organization_commission_other.approver_id, bonus: @organization_commission_other.bonus, bonus_reference: @organization_commission_other.bonus_reference, commission_no: @organization_commission_other.commission_no, financer_id: @organization_commission_other.financer_id, organization_charge_other_id: @organization_commission_other.organization_charge_other_id, user_id: @organization_commission_other.user_id, workflow_state: @organization_commission_other.workflow_state }
    end

    assert_redirected_to organization_commission_other_path(assigns(:organization_commission_other))
  end

  test "should show organization_commission_other" do
    get :show, id: @organization_commission_other
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_commission_other
    assert_response :success
  end

  test "should update organization_commission_other" do
    patch :update, id: @organization_commission_other, organization_commission_other: { approver_id: @organization_commission_other.approver_id, bonus: @organization_commission_other.bonus, bonus_reference: @organization_commission_other.bonus_reference, commission_no: @organization_commission_other.commission_no, financer_id: @organization_commission_other.financer_id, organization_charge_other_id: @organization_commission_other.organization_charge_other_id, user_id: @organization_commission_other.user_id, workflow_state: @organization_commission_other.workflow_state }
    assert_redirected_to organization_commission_other_path(assigns(:organization_commission_other))
  end

  test "should destroy organization_commission_other" do
    assert_difference('OrganizationCommissionOther.count', -1) do
      delete :destroy, id: @organization_commission_other
    end

    assert_redirected_to organization_commission_others_path
  end
end
