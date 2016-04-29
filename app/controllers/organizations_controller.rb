class OrganizationsController < ApplicationController
  before_action :authenticate,:current_user
  before_action :set_organization, only: [:show, :edit, :update, :destroy,
                                          :finish_check, :set_user]

  # GET /organizations
  # GET /organizations.json
  def index
      @organizations = Organization.managed_by_users(current_user.id).page params[:page]
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    render :show, layout: "simple"
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    @organization.user_id = session[:current_user_id]

    respond_to do |format|
      if @organization.save
        format.html { redirect_to organizations_url, notice: '机构信息已成功创建.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to organizations_url, notice: '机构信息已成功修改.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #查询 
  def query
    if params[:organization] && params[:organization][:name].length > 0
      @organizations = Organization.by_partial_name(params[:organization][:name]).page params[:page]
      @organization = Organization.new(name: params[:organization][:name])
    else
      redirect_to organizations_url
      return
    end
    render :index
  end

  #等待复核的机构列表
  def list_check
    @organizations = Organization.with_new_state.page params[:page]
  end

  #复核机构信息完成操作
  def finish_check
    @organization.finish_check!
    redirect_to organizations_list_check_path, 
                notice: "机构 #{@organization.name} 的资料已审核通过."
  end
  
  def list_total#所有机构列表,支持查询
    if params[:organization] && params[:organization][:name].length > 0
      @organizations = Organization.by_partial_name(params[:organization][:name]).page params[:page]
      @organization = Organization.new(name: params[:organization][:name])
    else
      @organizations = Organization.all.page params[:page]
    end
  end

  def list_set_user #机构列表,用于更改所属的业务员,支持查询,可考虑与上面代码合并
    if params[:organization] && params[:organization][:name].length > 0
      @organizations = Organization.by_partial_name(params[:organization][:name]).page params[:page]
      @organization = Organization.new(name: params[:organization][:name])
    else
      @organizations = Organization.all.page params[:page]
    end
  end

  def set_user #更改机构所属的业务员
    if params[:organization] && params[:organization][:user_id] && @organization.update(user: User.find(params[:organization][:user_id]))
      redirect_to organizations_list_set_user_path , notice: "该客户的业务员已成功更改为#{User.find(params[:organization][:user_id]).name}."
    else
      render :set_user 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :abbr, :address, :person_in_charge, :email, :tel, :fax, :contact_person, :contact_tel, :contact_fax, :start_date, :workflow_state, :user_id, :is_valid)
    end
end
