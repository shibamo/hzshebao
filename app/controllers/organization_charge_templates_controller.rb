class OrganizationChargeTemplatesController < ApplicationController

  before_action :set_organization_charge_template, only: [:show, :edit, :update, :destroy]
  before_action :set_organization_customer, only: [:new, :create, :show, :edit]
  before_action :set_organization, only:[:list_by_organization]

  # GET /organization_charge_templates
  # GET /organization_charge_templates.json
  def index
    @organization_charge_templates = OrganizationChargeTemplate.all
  end

  # GET /organization_charge_templates/1
  # GET /organization_charge_templates/1.json
  def show
  end

  # GET /organization_charge_templates/new
  def new
    @organization_charge_template = OrganizationChargeTemplate.new
    @organization_charge_template.organization_customer = @organization_customer
  end

  # GET /organization_charge_templates/1/edit
  def edit

  end

  # POST /organization_charge_templates
  # POST /organization_charge_templates.json
  def create
    @organization_charge_template = OrganizationChargeTemplate.new(organization_charge_template_params)
    @organization_charge_template.user = current_user
    @organization_charge_template.organization_customer = @organization_customer
    @organization_charge_template.organization = @organization_customer.organization

    respond_to do |format|
      if @organization_charge_template.save
        format.html { redirect_to organization_customers_list_by_organization_path(organization_id: @organization_customer.organization.id), 
          notice: '机构员工客户缴费模板已创建.' }
        format.json { render :show, status: :created, location: @organization_charge_template }
      else
        format.html { render :new }
        format.json { render json: @organization_charge_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_charge_templates/1
  # PATCH/PUT /organization_charge_templates/1.json
  def update
    respond_to do |format|
      if @organization_charge_template.update(organization_charge_template_params)
        format.html { redirect_to organization_customers_list_by_organization_path(organization_id: @organization_charge_template.organization.id), 
          notice: '机构员工客户缴费模板已修改.' }
        format.json { render :show, status: :ok, location: @organization_charge_template }
      else
        format.html { render :edit }
        format.json { render json: @organization_charge_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_charge_templates/1
  # DELETE /organization_charge_templates/1.json
  def destroy
    @organization_charge_template.destroy
    respond_to do |format|
      format.html { redirect_to organization_charge_templates_url, notice: 'Organization charge template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_by_organization
    @organization_charge_templates = OrganizationChargeTemplate.of_organization(@organization.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_charge_template
      @organization_charge_template = OrganizationChargeTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_charge_template_params
      params.require(:organization_charge_template).permit(:organization_customer_id, 
        :user_id, :price_shebao_base, :price_shebao_qiye, :price_shebao_geren, 
        :price_canbao, :price_shebao_guanli, :price_gongjijin_base, :price_gongjijin_qiye, 
        :price_gongjijin_geren, :price_gongjijin_guanli, :price_geshui, :price_qita_1, 
        :price_qita_2, :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :comment)
    end

    def set_organization_customer
      if @organization_charge_template
        @organization_customer = @organization_charge_template.organization_customer
        return
      end
      if params[:organization_customer_id]
        @organization_customer = OrganizationCustomer.find(params[:organization_customer_id])
        return
      end
      if params[:organization_charge_template] && params[:organization_charge_template][:organization_customer_id].length>0
        @organization_customer = OrganizationCustomer.find(params[:organization_charge_template][:organization_customer_id])
        return
      end
    end

    def set_organization
      if params[:organization_id]
        @organization = Organization.find(params[:organization_id])
        return
      end
    end
end
