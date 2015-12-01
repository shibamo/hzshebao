class OrganzationCommissionsController < ApplicationController
  before_action :set_organzation_commission, only: [:show, :edit, :update, :destroy]

  # GET /organzation_commissions
  # GET /organzation_commissions.json
  def index
    @organzation_commissions = OrganzationCommission.all
  end

  # GET /organzation_commissions/1
  # GET /organzation_commissions/1.json
  def show
  end

  # GET /organzation_commissions/new
  def new
    @organzation_commission = OrganzationCommission.new
  end

  # GET /organzation_commissions/1/edit
  def edit
  end

  # POST /organzation_commissions
  # POST /organzation_commissions.json
  def create
    @organzation_commission = OrganzationCommission.new(organzation_commission_params)

    respond_to do |format|
      if @organzation_commission.save
        format.html { redirect_to @organzation_commission, notice: 'Organzation commission was successfully created.' }
        format.json { render :show, status: :created, location: @organzation_commission }
      else
        format.html { render :new }
        format.json { render json: @organzation_commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organzation_commissions/1
  # PATCH/PUT /organzation_commissions/1.json
  def update
    respond_to do |format|
      if @organzation_commission.update(organzation_commission_params)
        format.html { redirect_to @organzation_commission, notice: 'Organzation commission was successfully updated.' }
        format.json { render :show, status: :ok, location: @organzation_commission }
      else
        format.html { render :edit }
        format.json { render json: @organzation_commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organzation_commissions/1
  # DELETE /organzation_commissions/1.json
  def destroy
    @organzation_commission.destroy
    respond_to do |format|
      format.html { redirect_to organzation_commissions_url, notice: 'Organzation commission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organzation_commission
      @organzation_commission = OrganzationCommission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organzation_commission_params
      params.require(:organzation_commission).permit(:commission_no, :organization_charge_total_id, :user_id, :bonus_reference, :bonus, :approver_id, :financer_id, :workflow_state)
    end
end
