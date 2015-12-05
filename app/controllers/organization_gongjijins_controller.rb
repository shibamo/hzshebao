class OrganizationGongjijinsController < ApplicationController
  before_action :set_organization_gongjijin, only: [:show, :edit, :update, :destroy]

  # GET /organization_gongjijins
  # GET /organization_gongjijins.json
  def index
    @organization_gongjijins = OrganizationGongjijin.all
  end

  # GET /organization_gongjijins/1
  # GET /organization_gongjijins/1.json
  def show
  end

  # GET /organization_gongjijins/new
  def new
    @organization_gongjijin = OrganizationGongjijin.new
  end

  # GET /organization_gongjijins/1/edit
  def edit
  end

  # POST /organization_gongjijins
  # POST /organization_gongjijins.json
  def create
    @organization_gongjijin = OrganizationGongjijin.new(organization_gongjijin_params)

    respond_to do |format|
      if @organization_gongjijin.save
        format.html { redirect_to @organization_gongjijin, notice: 'Organization gongjijin was successfully created.' }
        format.json { render :show, status: :created, location: @organization_gongjijin }
      else
        format.html { render :new }
        format.json { render json: @organization_gongjijin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_gongjijins/1
  # PATCH/PUT /organization_gongjijins/1.json
  def update
    respond_to do |format|
      if @organization_gongjijin.update(organization_gongjijin_params)
        format.html { redirect_to @organization_gongjijin, notice: 'Organization gongjijin was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_gongjijin }
      else
        format.html { render :edit }
        format.json { render json: @organization_gongjijin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_gongjijins/1
  # DELETE /organization_gongjijins/1.json
  def destroy
    @organization_gongjijin.destroy
    respond_to do |format|
      format.html { redirect_to organization_gongjijins_url, notice: 'Organization gongjijin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_gongjijin
      @organization_gongjijin = OrganizationGongjijin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_gongjijin_params
      params.require(:organization_gongjijin).permit(:organization_customer_id, :account_no, :workflow_state)
    end
end
