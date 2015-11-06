class OrganizationCharge < ActiveRecord::Base
  include ModelHelper  
  
  belongs_to :organization_charge_total
  
end
