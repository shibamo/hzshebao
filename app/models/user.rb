class User < ActiveRecord::Base
	belongs_to :department
	has_many :single_customers
	has_many :departments

	#以下为建立用户->角色->功能点的多重 m:n 关联关系, functions为获取到拥有访问权限的功能点列表
	has_many :role_users
	has_many :roles , through: :role_users, inverse_of: :users
	has_many :role_functions , through: :roles
	has_many :functions, through: :role_functions

	#该用户的直接下属array, 未来可以使用递归改造获得所有下属array	
	scope :direct_subordinates, ->(user_id) {where(department_id: Department.departments_managed_by(user_id).collect{|x| x.id})} 

	validates_presence_of :name, :logon_name, :department_id, message: "登录名,姓名与部门都不能为空"
	validates_uniqueness_of :logon_name,:name ,  message: "为避免错误,登录名与姓名都不能与已有记录相同"

	def direct_subordinates
		User.direct_subordinates(self.id)
	end
	def direct_subordinates_with_self
		(User.direct_subordinates(self.id) << self).uniq
	end
end
