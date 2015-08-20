require 'test_helper'

class CustomerIdCardPicturesControllerTest < ActionController::TestCase
  setup do
    @customer_id_card_picture = customer_id_card_pictures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_id_card_pictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_id_card_picture" do
    assert_difference('CustomerIdCardPicture.count') do
      post :create, customer_id_card_picture: { content_type: @customer_id_card_picture.content_type, customer_id: @customer_id_card_picture.customer_id, customer_type: @customer_id_card_picture.customer_type, file_name: @customer_id_card_picture.file_name, file_raw: @customer_id_card_picture.file_raw, user_id: @customer_id_card_picture.user_id }
    end

    assert_redirected_to customer_id_card_picture_path(assigns(:customer_id_card_picture))
  end

  test "should show customer_id_card_picture" do
    get :show, id: @customer_id_card_picture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_id_card_picture
    assert_response :success
  end

  test "should update customer_id_card_picture" do
    patch :update, id: @customer_id_card_picture, customer_id_card_picture: { content_type: @customer_id_card_picture.content_type, customer_id: @customer_id_card_picture.customer_id, customer_type: @customer_id_card_picture.customer_type, file_name: @customer_id_card_picture.file_name, file_raw: @customer_id_card_picture.file_raw, user_id: @customer_id_card_picture.user_id }
    assert_redirected_to customer_id_card_picture_path(assigns(:customer_id_card_picture))
  end

  test "should destroy customer_id_card_picture" do
    assert_difference('CustomerIdCardPicture.count', -1) do
      delete :destroy, id: @customer_id_card_picture
    end

    assert_redirected_to customer_id_card_pictures_path
  end
end
