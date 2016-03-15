class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #skip_before_action :verify_authenticity_token, if: :json_request?
  
  add_flash_types :error

  before_action :authenticate
  before_action :current_user
  before_action :set_users

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

  def set_users
    @users = User.all
  end

  #用于导出到Excel时设置单元格的日期格式
  def default_excel_date_format
    @default_excel_date_format ||= Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')
  end

  #用于导出到Excel时设置单元格的货币数字格式
  def default_excel_money_format
    @default_excel_money_format ||= Spreadsheet::Format.new(:number_format => '0.00')
  end
end
