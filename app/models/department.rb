class Department < ActiveRecord::Base
	has_many :users
	belongs_to :head , class_name: "User", foreign_key:"user_id"

	default_scope {order(:display_order)}

	scope :departments_managed_by, ->(user_id) {where(user_id: user_id)}

end
