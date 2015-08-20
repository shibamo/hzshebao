class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :print_form]
  before_action :set_single_customer, only: [:index, :new, :create, :update, :print_form]
  # GET /contracts
  # GET /contracts.json
  def index
    @contracts = Contract.of_same_customer(params[:single_customer_id])
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
  end

  # GET /contracts/new
  def new
    @contract = Contract.new
    @contract.work = "办公文员"
    @contract.salary = "不低于本市最低工资标准"
    @contract.location = "杭州"
  end

  # GET /contracts/1/edit
  def edit

  end

  # POST /contracts
  # POST /contracts.json
  def create
    @contract = Contract.new(contract_params)
    @contract.user_id=session["current_user_id"]
    @contract.single_customer=@single_customer

    render :new and return unless @contract.validate_date(@contract.start_date, @contract.end_date,@single_customer.id,@contract.id) 

    respond_to do |format|
      if @contract.save
        format.html { redirect_to root_path, notice: "个人客户 #{@single_customer.name} 的劳动合同已建立." }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    render :new and return unless @contract.validate_date(@contract.start_date, @contract.end_date,@single_customer.id,@contract.id)

    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to @contract, notice: "个人客户 #{@single_customer.name}'的劳动合同已更改." }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    @contract.destroy
    respond_to do |format|
      format.html { redirect_to contracts_url, notice: 'Contract was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def print_form
    @single_customer = @contract.single_customer
    @sign_up_att_id = MoneyArrivalFile.where(business_type: "Contract", main_object_id: @contract.id).maximum(:id)
    render layout: "simple"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      # routes.rb中get :print_form => 'contracts#print_form'传入的是:contract_id而不是:id
      @contract = params[:id].nil? ? Contract.find(params[:contract_id]) : Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:contract).permit(:single_customer_id, :user_id, :start_date, :end_date, :work, :salary, :location)
    end

    def set_single_customer
      @single_customer = SingleCustomer.find(params[:single_customer_id])
    end
end
