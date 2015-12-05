require 'test_helper'

class OrganizationGongjijinsControllerTest < ActionController::TestCase
  setup do
    @organization_gongjijin = organization_gongjijins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_gongjijins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_gongjijin" do
    assert_difference('OrganizationGongjijin.count') do
      post :create, organization_gongjijin: { account_no: @organization_gongjijin.account_no, organization_customer_id: @organization_gongjijin.organization_customer_id, workflow_state: @organization_gongjijin.workflow_state }
    end

    assert_redirected_to organization_gongjijin_path(assigns(:organization_gongjijin))
  end

  test "should show organization_gongjijin" do
    get :show, id: @organization_gongjijin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_gongjijin
    assert_response :success
  end

  test "should update organization_gongjijin" do
    patch :update, id: @organization_gongjijin, organization_gongjijin: { account_no: @organization_gongjijin.account_no, organization_customer_id: @organization_gongjijin.organization_customer_id, workflow_state: @organization_gongjijin.workflow_state }
    assert_redirected_to organization_gongjijin_path(assigns(:organization_gongjijin))
  end

  test "should destroy organization_gongjijin" do
    assert_difference('OrganizationGongjijin.count', -1) do
      delete :destroy, id: @organization_gongjijin
    end

    assert_redirected_to organization_gongjijins_path
  end
end
