class Function < ActiveRecord::Base
	#以下为建立功能点->角色->用户的多重 m:n 关联关系
	has_many :role_functions
	has_many :roles , through: :role_functions, inverse_of: :functions
	has_many :role_users, through: :roles
	has_many :users , through: :role_users

	default_scope {order(:controller, :action)}
end
