class OrganizationChargeTotalsController < ApplicationController
  before_action :set_organization_charge_total, only: [:show, :edit, :update, :destroy]
  before_action :set_organization, only: [:list, :new, :create]

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

  # PATCH/PUT /organization_charge_totals/1
  # PATCH/PUT /organization_charge_totals/1.json
  def update
    respond_to do |format|
      if @organization_charge_total.update(organization_charge_total_params)
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
end
