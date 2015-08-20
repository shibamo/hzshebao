class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  add_flash_types :error

  before_action :authenticate
  before_action :current_user

  def authenticate
  	redirect_to user_login_path unless session[:current_user_id]
    return
  end

  def require_admin
  	unless User.find(session["current_user_id"]).is_admin
	  	flash[:danger] = '该功能需要管理员用户权限'
	  	redirect_to user_login_path
  	end
  end

	def require_leader
		unless User.find(session["current_user_id"]).is_leader
			flash[:danger] = '该功能需要公司领导用户权限'
  		redirect_to user_login_path
  	end
  end

  def current_user
    @current_user ||=  User.find(session["current_user_id"]) if session["current_user_id"]
  end
end
