class OrganizationCharge < ActiveRecord::Base
  include ModelHelper  
  
  belongs_to :organization_charge_total
  belongs_to :organization
  belongs_to :organization_customer
  
end
