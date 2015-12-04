class OrganizationCustomersController < ApplicationController
  before_action :set_organization_customer, only: [:show, :edit, :update, :destroy, 
                                                    :finish_check]
  before_action :set_organizations
  before_action :set_organization, only: [:list_by_organization, :new, :create, :show, :edit]


  # GET /organization_customers
  # GET /organization_customers.json
  def index
    @organization_customers = OrganizationCustomer.all
  end

  # GET /organization_customers/1
  # GET /organization_customers/1.json
  def show
    @organization = @organization_customer.organization
    render :show, layout: "simple"
  end

  # GET /organization_customers/new
  def new
    @organization_customer = OrganizationCustomer.new
    @organization_customer.organization = @organization if @organization
  end

  # GET /organization_customers/1/edit
  def edit
  end

  # POST /organization_customers
  # POST /organization_customers.json
  def create
    @organization_customer = OrganizationCustomer.new(organization_customer_params)
    @organization_customer.user_id = session[:current_user_id]


    respond_to do |format|
      if @organization_customer.save
        format.html { redirect_to @organization_customer, notice: '机构员工客户资料信息已成功创建.' }
        format.json { render :show, status: :created, location: @organization_customer }
      else
        format.html { render :new }
        format.json { render json: @organization_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_customers/1
  # PATCH/PUT /organization_customers/1.json
  def update
    respond_to do |format|
      if @organization_customer.update(organization_customer_params)
        format.html { redirect_to @organization_customer, notice: 'Organization customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_customer }
      else
        format.html { render :edit }
        format.json { render json: @organization_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_customers/1
  # DELETE /organization_customers/1.json
  def destroy
    @organization_customer.destroy
    respond_to do |format|
      format.html { redirect_to organization_customers_url, notice: 'Organization customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_by_organization
    @organization_customers = OrganizationCustomer.by_organization_ids(@organization.id).page params[:page]

  end

  #等待复核的机构员工客户列表
  def list_check
    @organization_customers = OrganizationCustomer.with_new_state.page params[:page]
  end

  #复核机构员工客户信息完成操作
  def finish_check
    ActiveRecord::Base.transaction do
      @organization_customer.finish_check!
      @organization_customer.update(is_valid: 1)
    end
    redirect_to organization_customers_list_check_path, 
                notice: "机构员工客户 #{@organization_customer.name} 的资料已审核通过."
  end

  #机构员工客户信息列表与查询
  def list_edit
    if params[:organization_customer] && params[:organization_customer][:name]
      @organization_customers = OrganizationCustomer.by_partial_name(params[:organization_customer][:name]).page params[:page]
      @organization_customer = OrganizationCustomer.new(organization_customer_params)
    else
      @organization_customers = OrganizationCustomer.all.page params[:page]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_customer
      @organization_customer = OrganizationCustomer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_customer_params
      params.require(:organization_customer).permit(:name, :organization_id, :gender, :ethnic_name, :birth, :id_no, 
                :id_address, :hukou_type, :education, :tel, :other_contact_person, :other_contact_call, 
                :qq, :wechat, :email, :communication_address, :is_doc_for_shebao, :is_doc_for_shigong, 
                :is_doc_for_shenggong, :is_doc_for_butuichajia, :is_doc_for_xufei, :is_doc_for_qita, 
                :is_usage_zhengchang, :is_usage_ruxue, :is_usage_luohu, :is_usage_shenyu, :is_usage_yiliao, 
                :is_usage_gouche, :is_usage_goufang, :is_usage_daikuan, :creator, :creator_tel, :comment, 
                :user_id, :input_date, :document_no, :comment_for_qita, :workflow_state, :is_valid, 
                :valid_start, :valid_end)
    end

    def set_organization
      if @organization_customer
        @organization = @organization_customer.organization
        return
      end
      if params[:organization_id]
        @organization = Organization.find(params[:organization_id])
        return
      end
      if params[:organization_customer] && params[:organization_customer][:organization_id].length>0
        @organization = Organization.find(params[:organization_customer][:organization_id])
        return
      end
    end

    def set_organizations
      @organizations = Organization.order_by_name
    end
end
