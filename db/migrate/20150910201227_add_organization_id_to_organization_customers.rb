class AddOrganizationIdToOrganizationCustomers < ActiveRecord::Migration
  def change
    add_column :organization_customers, :organization_id, :integer
  end
end
