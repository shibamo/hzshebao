require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    @organization = organizations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post :create, organization: { abbr: @organization.abbr, address: @organization.address, contact_fax: @organization.contact_fax, contact_person: @organization.contact_person, contact_tel: @organization.contact_tel, email: @organization.email, fax: @organization.fax, is_valid: @organization.is_valid, name: @organization.name, person_in_charge: @organization.person_in_charge, start_date: @organization.start_date, tel: @organization.tel, user_id: @organization.user_id, workflow_state: @organization.workflow_state }
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should show organization" do
    get :show, id: @organization
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization
    assert_response :success
  end

  test "should update organization" do
    patch :update, id: @organization, organization: { abbr: @organization.abbr, address: @organization.address, contact_fax: @organization.contact_fax, contact_person: @organization.contact_person, contact_tel: @organization.contact_tel, email: @organization.email, fax: @organization.fax, is_valid: @organization.is_valid, name: @organization.name, person_in_charge: @organization.person_in_charge, start_date: @organization.start_date, tel: @organization.tel, user_id: @organization.user_id, workflow_state: @organization.workflow_state }
    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization
    end

    assert_redirected_to organizations_path
  end
end
