class Role < ActiveRecord::Base
	has_many :role_users
	has_many :users , through: :role_users, inverse_of: :roles

	has_many :role_functions
	has_many :functions , through: :role_functions, inverse_of: :roles

	validates_presence_of :name,  message: "角色名不能为空"

	def user_ids
		self.users.collect(&:id)
	end

	def function_ids
		self.functions.collect(&:id)
	end

end
