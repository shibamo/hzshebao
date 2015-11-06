class RemoveOrganzationIdFromOrganizationCustomers < ActiveRecord::Migration
  def change
    remove_column :organization_customers, :organzation_id, :integer
  end
end
