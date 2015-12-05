require 'test_helper'

class OrganizationShebaosControllerTest < ActionController::TestCase
  setup do
    @organization_shebao = organization_shebaos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_shebaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_shebao" do
    assert_difference('OrganizationShebao.count') do
      post :create, organization_shebao: { account_no: @organization_shebao.account_no, organization_customer_id: @organization_shebao.organization_customer_id, workflow_state: @organization_shebao.workflow_state }
    end

    assert_redirected_to organization_shebao_path(assigns(:organization_shebao))
  end

  test "should show organization_shebao" do
    get :show, id: @organization_shebao
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_shebao
    assert_response :success
  end

  test "should update organization_shebao" do
    patch :update, id: @organization_shebao, organization_shebao: { account_no: @organization_shebao.account_no, organization_customer_id: @organization_shebao.organization_customer_id, workflow_state: @organization_shebao.workflow_state }
    assert_redirected_to organization_shebao_path(assigns(:organization_shebao))
  end

  test "should destroy organization_shebao" do
    assert_difference('OrganizationShebao.count', -1) do
      delete :destroy, id: @organization_shebao
    end

    assert_redirected_to organization_shebaos_path
  end
end
