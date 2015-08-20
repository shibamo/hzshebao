require 'test_helper'

class GongjijinsControllerTest < ActionController::TestCase
  setup do
    @gongjijin = gongjijins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gongjijins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gongjijin" do
    assert_difference('Gongjijin.count') do
      post :create, gongjijin: { account_no: @gongjijin.account_no, single_customer_id: @gongjijin.single_customer_id, workflow_state: @gongjijin.workflow_state }
    end

    assert_redirected_to gongjijin_path(assigns(:gongjijin))
  end

  test "should show gongjijin" do
    get :show, id: @gongjijin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gongjijin
    assert_response :success
  end

  test "should update gongjijin" do
    patch :update, id: @gongjijin, gongjijin: { account_no: @gongjijin.account_no, single_customer_id: @gongjijin.single_customer_id, workflow_state: @gongjijin.workflow_state }
    assert_redirected_to gongjijin_path(assigns(:gongjijin))
  end

  test "should destroy gongjijin" do
    assert_difference('Gongjijin.count', -1) do
      delete :destroy, id: @gongjijin
    end

    assert_redirected_to gongjijins_path
  end
end
