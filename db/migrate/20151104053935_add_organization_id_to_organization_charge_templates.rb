class AddOrganizationIdToOrganizationChargeTemplates < ActiveRecord::Migration
  def change
    add_column :organization_charge_templates, :organization_id, :integer
  end
end
