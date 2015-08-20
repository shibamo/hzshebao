require 'bcrypt'
class UsersController < ApplicationController
  include ApplicationHelper #引入是因为验证通过时需要调用ApplicationHelper.#refresh_user_functions强制刷新用户权限表

  before_action :set_user, only: [:show, :edit, :update, :destroy, :reset_password]
  before_action :set_departments
  
  before_action :transform_password, only: [ :update, :create]
  before_action :require_admin, except: [:login, :auth, :reset_password, :logout, :update]
  skip_before_action :authenticate, only:[:login, :auth] #authenticate method defined in ApplicationController
  skip_before_action :current_user, only:[:login, :auth]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to users_url and return
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    #@user.password_digest = BCrypt::Password.create(params[:user][:password_digest])
    respond_to do |format|
      if @user.save

        format.html { redirect_to users_url, notice: "用户'#{@user.name}'已创建成功." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: "用户'#{@user.name}'信息已成功修改" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    redirect_to users_url and return
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset_password
    if session[:current_user_id].to_i != params[:id].to_i and !User.find(session[:current_user_id]).is_admin
      redirect_to(root_path, notice: "无权修改他人密码!") and return
    end
    @user = User.find(params[:id])
  end

  def login
    @user = User.find_by_id(params[:id])
    @user ||= User.new
  end

  def logout
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to root_path
  end

  def auth
    @user = User.find_by(logon_name: params[:user][:logon_name])
    if @user and BCrypt::Password.new(@user.password_digest) == params[:user][:password_digest]
      #验证成功
      session[:current_user_id] = @user.id
      refresh_user_functions(@user) #强制刷新用户权限表
      redirect_to root_path and return
    else
      flash[:danger] = '验证失败,用户名/口令错误!'
      redirect_to user_login_path(@user)
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if params[:user][:password_digest]
        params.require(:user).permit(:name, :password_digest, :logon_name, :is_valid, :is_leader, :is_admin, :department_id)
      else
        params.require(:user).permit(:name, :logon_name, :is_valid, :is_leader, :is_admin, :department_id)
      end
    end

    def set_departments
      @departments = departments
    end

    def departments
      Department.all
    end

    #将明文密码加密变形
    def transform_password
      if params[:user][:password_digest]
        params[:user][:password_digest]=BCrypt::Password.create(params[:user][:password_digest])
      end
    end
end
