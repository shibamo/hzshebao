class OrganizationCharge < ActiveRecord::Base
  include ModelHelper  
  include OrganizationChargeCalculateHelper
  
  belongs_to :organization_charge_total
  belongs_to :organization
  belongs_to :organization_customer
  
  scope :by_customer, ->(organization_ids) {where(organization_customer_id: organization_ids).order(start_date: :desc)}

end
