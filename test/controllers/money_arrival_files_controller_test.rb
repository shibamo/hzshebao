require 'test_helper'

class MoneyArrivalFilesControllerTest < ActionController::TestCase
  setup do
    @money_arrival_file = money_arrival_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:money_arrival_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create money_arrival_file" do
    assert_difference('MoneyArrivalFile.count') do
      post :create, money_arrival_file: { business_type: @money_arrival_file.business_type, content_type: @money_arrival_file.content_type, file_raw: @money_arrival_file.file_raw, filename: @money_arrival_file.filename, main_object_id: @money_arrival_file.main_object_id, user_id: @money_arrival_file.user_id }
    end

    assert_redirected_to money_arrival_file_path(assigns(:money_arrival_file))
  end

  test "should show money_arrival_file" do
    get :show, id: @money_arrival_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @money_arrival_file
    assert_response :success
  end

  test "should update money_arrival_file" do
    patch :update, id: @money_arrival_file, money_arrival_file: { business_type: @money_arrival_file.business_type, content_type: @money_arrival_file.content_type, file_raw: @money_arrival_file.file_raw, filename: @money_arrival_file.filename, main_object_id: @money_arrival_file.main_object_id, user_id: @money_arrival_file.user_id }
    assert_redirected_to money_arrival_file_path(assigns(:money_arrival_file))
  end

  test "should destroy money_arrival_file" do
    assert_difference('MoneyArrivalFile.count', -1) do
      delete :destroy, id: @money_arrival_file
    end

    assert_redirected_to money_arrival_files_path
  end
end
