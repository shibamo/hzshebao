class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy, :set_users, :update_users, :set_functions, :update_functions]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_users
  end

  def update_users
    new_user_ids = params[:role][:user_ids].collect{|t| t.to_i} - [0,]
    old_user_ids = @role.role_users.collect(&:user_id)
    (old_user_ids-new_user_ids).each {|t| RoleUser.where(role_id: @role.id , user_id: t).first.delete}
    (new_user_ids-old_user_ids).each {|t| RoleUser.create role_id: @role.id, user_id: t }
    redirect_to roles_url , notice: '该角色的用户已设置完毕.' and return
  end

  def set_functions
  end

  def update_functions
    new_function_ids = params[:role][:function_ids].collect{|t| t.to_i} - [0,]
    old_function_ids = @role.role_functions.collect(&:function_id)
    (old_function_ids-new_function_ids).each {|t| RoleFunction.where(role_id: @role.id , function_id: t).first.delete}
    (new_function_ids-old_function_ids).each {|t| RoleFunction.create role_id: @role.id, function_id: t }
    redirect_to roles_url , notice: '该角色的可用功能点已设置完毕.' and return
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = params[:id] ? Role.find(params[:id]) : Role.find(params[:role_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name)
    end
end
