require 'test_helper'

class RenewalsControllerTest < ActionController::TestCase
  setup do
    @renewal = renewals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:renewals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create renewal" do
    assert_difference('Renewal.count') do
      post :create, renewal: { comment: @renewal.comment, single_customer_id: @renewal.single_customer_id, user_id: @renewal.user_id, workflow_state: @renewal.workflow_state }
    end

    assert_redirected_to renewal_path(assigns(:renewal))
  end

  test "should show renewal" do
    get :show, id: @renewal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @renewal
    assert_response :success
  end

  test "should update renewal" do
    patch :update, id: @renewal, renewal: { comment: @renewal.comment, single_customer_id: @renewal.single_customer_id, user_id: @renewal.user_id, workflow_state: @renewal.workflow_state }
    assert_redirected_to renewal_path(assigns(:renewal))
  end

  test "should destroy renewal" do
    assert_difference('Renewal.count', -1) do
      delete :destroy, id: @renewal
    end

    assert_redirected_to renewals_path
  end
end
