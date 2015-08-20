require 'test_helper'

class ShebaoBasesControllerTest < ActionController::TestCase
  setup do
    @shebao_basis = shebao_bases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shebao_bases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shebao_basis" do
    assert_difference('ShebaoBase.count') do
      post :create, shebao_basis: { base: @shebao_basis.base, user_id: @shebao_basis.user_id, year: @shebao_basis.year }
    end

    assert_redirected_to shebao_basis_path(assigns(:shebao_basis))
  end

  test "should show shebao_basis" do
    get :show, id: @shebao_basis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shebao_basis
    assert_response :success
  end

  test "should update shebao_basis" do
    patch :update, id: @shebao_basis, shebao_basis: { base: @shebao_basis.base, user_id: @shebao_basis.user_id, year: @shebao_basis.year }
    assert_redirected_to shebao_basis_path(assigns(:shebao_basis))
  end

  test "should destroy shebao_basis" do
    assert_difference('ShebaoBase.count', -1) do
      delete :destroy, id: @shebao_basis
    end

    assert_redirected_to shebao_bases_path
  end
end
