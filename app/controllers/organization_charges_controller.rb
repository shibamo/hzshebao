class OrganizationChargesController < ApplicationController
  before_action :set_organization_charge, only: [:show, :edit, :update, :destroy]
  before_action :set_model_class

  # GET /organization_charges
  # GET /organization_charges.json
  def index
    @organization_charges = OrganizationCharge.all
  end

  # GET /organization_charges/1
  # GET /organization_charges/1.json
  def show
  end

  # GET /organization_charges/new
  def new
    @organization_charge = OrganizationCharge.new
  end

  # GET /organization_charges/1/edit
  def edit
  end

  # POST /organization_charges
  # POST /organization_charges.json
  def create
    @organization_charge = OrganizationCharge.new(organization_charge_params)

    respond_to do |format|
      if @organization_charge.save
        format.html { redirect_to @organization_charge, notice: 'Organization charge was successfully created.' }
        format.json { render :show, status: :created, location: @organization_charge }
      else
        format.html { render :new }
        format.json { render json: @organization_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_charges/1
  # PATCH/PUT /organization_charges/1.json
  def update
    respond_to do |format|
      if @organization_charge.update(organization_charge_params)
        format.html { redirect_to @organization_charge, notice: 'Organization charge was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_charge }
      else
        format.html { render :edit }
        format.json { render json: @organization_charge.errors, status: :unprocessable_entity }
      end
    end
  end
############################################################################################
  def list_by_customer
    if params[:organization_customer_id]
      @organization_charges = @model_class.by_customer(params[:organization_customer_id])
      @organization_customer = OrganizationCustomer.find(params[:organization_customer_id])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_charge
      @organization_charge = OrganizationCharge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_charge_params
      params.require(:organization_charge).permit(:organization_charge_total_id, :organization_customer_id, :organization_id, :user_id, :price_shebao_base, :price_shebao_qiye, :price_shebao_geren, :price_canbao, :price_shebao_guanli, :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :start_date, :end_date, :comment)
    end

    def set_model_class
      @model_class = OrganizationCharge
    end
end
