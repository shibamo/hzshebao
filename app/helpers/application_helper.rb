module ApplicationHelper
	def gender_text_of_chinese(gender)
		gender==1 ? '男' : '女'
	end

	def bool_text_of_chinese(bool_value)
		bool_value ? '是' : '否'
	end

  def refresh_user_functions(user)
    functions = user.functions.collect{|f| f.controller + '|' + f.action}
    Rails.cache.write(user.id.to_s+"|"+"functions", functions, expires_in: 12.hours)
    return functions
  end

  def get_user_functions(user)
    functions = Rails.cache.read(user.id.to_s+"|"+"functions") || refresh_user_functions(user)
  end

	def can_u_a_c?(user, action, controller)
		#return true #对所有人开放所有权限,仅调试时使用
    return true if user.logon_name == "kingc" #用于troubleshooting

    get_user_functions(user).include? controller.to_s + '|' + action.to_s
	end
  
  def dialog_size_option(size_option)
    {small: "modal-sm", medium: "", large: "modal-lg"}[size_option]
  end


end

class Symbol
    def to_class
        Kernel.const_get(self)
    end
end

class String
    def to_class
        Kernel.const_get(self)
    end
end