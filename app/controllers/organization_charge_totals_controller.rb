class OrganizationChargeTotalsController < ApplicationController
  before_action :set_organization_charge_total, only: [:show, :edit, :update, :destroy]
  before_action :set_organization, only: [:list, :new, :create,:edit,:show]

  # GET /organization_charge_totals
  # GET /organization_charge_totals.json
  def index
    @organization_charge_totals = OrganizationChargeTotal.all
  end

  # GET /organization_charge_totals/1
  # GET /organization_charge_totals/1.json
  def show
  end

  # GET /organization_charge_totals/new
  def new
    @organization_charge_total = OrganizationChargeTotal.new
  end

  # GET /organization_charge_totals/1/edit
  def edit

  end

  # POST /organization_charge_totals
  # POST /organization_charge_totals.json
  def create
    @organization_charge_total = OrganizationChargeTotal.new(organization_charge_total_params)
    @organization_charge_total.user_id = current_user.id
    organization_charges = []
    organization_charges_params.reject{|t| t[:deleted]}.each do |t|
      t.delete :deleted
      oc = OrganizationCharge.new(t)
      oc.user_id = current_user.id
      oc.start_date = @organization_charge_total.start_date
      oc.end_date = @organization_charge_total.end_date
      oc.organization = @organization_charge_total.organization
      organization_charges.push oc
    end
    @organization_charge_total.organization_charges = organization_charges
    sum_organization_charge_total_fields @organization_charge_total, organization_charges

    respond_to do |format|
      if @organization_charge_total.save
        format.html { redirect_to @organization_charge_total, notice: 'Organization charge total was successfully created.' }
        format.json { render :show, status: :created, location: @organization_charge_total }
      else
        format.html { render :new }
        format.json { render json: @organization_charge_total.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_fields(source, destination, field_names)
    field_names.each {|f| source[f] = destination[f]}
  end

  def fill_fields(object, fill_value, field_names)
    field_names.each {|f| object[f] = fill_value}
  end

  # PATCH/PUT /organization_charge_totals/1
  # PATCH/PUT /organization_charge_totals/1.json
  def update
    @organization_charge_total = OrganizationChargeTotal.find(params[:organization_charge_total_id])
    @organization_charge_total.user_id = current_user.id
    @organization_charge_total.start_date = params[:organization_charge_total][:start_date]
    @organization_charge_total.end_date = params[:organization_charge_total][:end_date]
    @organization_charge_total.comment = params[:organization_charge_total][:comment]

    organization_charges = []
    organization_charges_params.each do |t|
      oc = OrganizationCharge.find(t[:id])
      oc.user_id = current_user.id
      oc.start_date = @organization_charge_total.start_date
      oc.end_date = @organization_charge_total.end_date
      if t[:deleted]
        fill_fields oc, 0, price_fields
      else
        copy_fields oc, t, price_fields
      end

      organization_charges.push oc
    end
    @organization_charge_total.organization_charges = organization_charges
    sum_organization_charge_total_fields @organization_charge_total, organization_charges

    respond_to do |format|
      if @organization_charge_total.save
        format.html { redirect_to @organization_charge_total, notice: 'Organization charge total was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_charge_total }
      else
        format.html { render :edit }
        format.json { render json: @organization_charge_total.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_charge_totals/1
  # DELETE /organization_charge_totals/1.json
  def destroy
    @organization_charge_total.destroy
    respond_to do |format|
      format.html { redirect_to organization_charge_totals_url, notice: 'Organization charge total was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list
    @organization_charge_totals = OrganizationChargeTotal.of_organization(@organization.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_charge_total
      @organization_charge_total = OrganizationChargeTotal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_charge_total_params
      params.require(:organization_charge_total).permit(
        :organization_id, :user_id, :price_shebao_base, :price_shebao_qiye, 
        :price_shebao_geren, :price_canbao, :price_shebao_guanli, 
        :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, 
        :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, 
        :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :start_date, 
        :end_date, :comment, :money_arrival_date, :money_check_date, :workflow_state)
    end

    #接收机构员工缴费对象数组
    def organization_charges_params
      params.require(:organization_charges).map do |t|
        t.permit(:id, :organization_customer_id, :price_shebao_base, :price_shebao_qiye, 
        :price_shebao_geren, :price_canbao, :price_shebao_guanli, 
        :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, 
        :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, 
        :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :deleted)
      end
    end

    #设置机构
    def set_organization
      if @organization_charge_total
        @organization = @organization_charge_total.organization
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

    #根据机构员工缴费明细数据汇总计算机构应付的各个项目金额
    def sum_organization_charge_total_fields(organization_charge_total, organization_charges)
      organization_charge_total.price_shebao_base = sum_array_field(organization_charges,:price_shebao_base)
      organization_charge_total.price_shebao_qiye = sum_array_field(organization_charges,:price_shebao_qiye)
      organization_charge_total.price_shebao_geren = sum_array_field(organization_charges,:price_shebao_geren)
      organization_charge_total.price_canbao = sum_array_field(organization_charges,:price_canbao)
      organization_charge_total.price_shebao_guanli = sum_array_field(organization_charges,:price_shebao_guanli)
      organization_charge_total.price_gongjijin_base = sum_array_field(organization_charges,:price_gongjijin_base)
      organization_charge_total.price_gongjijin_qiye = sum_array_field(organization_charges,:price_gongjijin_qiye)
      organization_charge_total.price_gongjijin_geren = sum_array_field(organization_charges,:price_gongjijin_geren)
      organization_charge_total.price_gongjijin_guanli = sum_array_field(organization_charges,:price_gongjijin_guanli)
      organization_charge_total.price_geshui = sum_array_field(organization_charges,:price_geshui)
      organization_charge_total.price_qita_1 = sum_array_field(organization_charges,:price_qita_1)
      organization_charge_total.price_qita_2 = sum_array_field(organization_charges,:price_qita_2)
      organization_charge_total.price_qita_3 = sum_array_field(organization_charges,:price_qita_3)
      organization_charge_total.price_bujiao = sum_array_field(organization_charges,:price_bujiao)
      organization_charge_total.price_yujiao = sum_array_field(organization_charges,:price_yujiao)
      organization_charge_total.price_gongzi = sum_array_field(organization_charges,:price_gongzi)
    end

    #计算字典数组的指定字段的和
    def sum_array_field(array, fieldName)
      array.reduce(0){|memo,obj| memo + obj[fieldName]}
    end

    #
    def price_fields
      return [:price_shebao_base, :price_shebao_qiye, 
        :price_shebao_geren, :price_canbao, :price_shebao_guanli, 
        :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, 
        :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, 
        :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi]
    end
end