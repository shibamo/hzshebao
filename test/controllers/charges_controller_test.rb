require 'test_helper'

class ChargesControllerTest < ActionController::TestCase
  setup do
    @charge = charges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:charges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create charge" do
    assert_difference('Charge.count') do
      post :create, charge: { charge_type: @charge.charge_type, end_date: @charge.end_date, is_lead_checked: @charge.is_lead_checked, lead_check_time: @charge.lead_check_time, money_arrival_state: @charge.money_arrival_state, money_arrival_time: @charge.money_arrival_time, months_bujiao: @charge.months_bujiao, months_cailiaofei: @charge.months_cailiaofei, months_fuwufei: @charge.months_fuwufei, months_gongjijin: @charge.months_gongjijin, months_shebao: @charge.months_shebao, price_bujiao: @charge.price_bujiao, price_cailiaofei: @charge.price_cailiaofei, price_fuwufei: @charge.price_fuwufei, price_gongjijin: @charge.price_gongjijin, price_shebao: @charge.price_shebao, shenbao_state: @charge.shenbao_state, shenbao_time: @charge.shenbao_time, single_customer_id: @charge.single_customer_id, start_date: @charge.start_date, user_id: @charge.user_id }
    end

    assert_redirected_to charge_path(assigns(:charge))
  end

  test "should show charge" do
    get :show, id: @charge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @charge
    assert_response :success
  end

  test "should update charge" do
    patch :update, id: @charge, charge: { charge_type: @charge.charge_type, end_date: @charge.end_date, is_lead_checked: @charge.is_lead_checked, lead_check_time: @charge.lead_check_time, money_arrival_state: @charge.money_arrival_state, money_arrival_time: @charge.money_arrival_time, months_bujiao: @charge.months_bujiao, months_cailiaofei: @charge.months_cailiaofei, months_fuwufei: @charge.months_fuwufei, months_gongjijin: @charge.months_gongjijin, months_shebao: @charge.months_shebao, price_bujiao: @charge.price_bujiao, price_cailiaofei: @charge.price_cailiaofei, price_fuwufei: @charge.price_fuwufei, price_gongjijin: @charge.price_gongjijin, price_shebao: @charge.price_shebao, shenbao_state: @charge.shenbao_state, shenbao_time: @charge.shenbao_time, single_customer_id: @charge.single_customer_id, start_date: @charge.start_date, user_id: @charge.user_id }
    assert_redirected_to charge_path(assigns(:charge))
  end

  test "should destroy charge" do
    assert_difference('Charge.count', -1) do
      delete :destroy, id: @charge
    end

    assert_redirected_to charges_path
  end
end
