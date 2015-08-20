class RenewalsController < ApplicationController
  before_action :set_renewal, only: [:show, :edit, :update, :destroy, :need_renew, 
                                      :finish_renew, :stop, :finish_restart,]

  # GET /renewals
  # GET /renewals.json
  def index
    @renewals = Renewal.all
  end

  # GET /renewals/1
  # GET /renewals/1.json
  def show
  end

  # GET /renewals/new
  def new
    @renewal = Renewal.new
  end

  # GET /renewals/1/edit
  def edit
  end

  # POST /renewals
  # POST /renewals.json
  def create
    @renewal = Renewal.new(renewal_params)

    respond_to do |format|
      if @renewal.save
        format.html { redirect_to @renewal, notice: 'Renewal was successfully created.' }
        format.json { render :show, status: :created, location: @renewal }
      else
        format.html { render :new }
        format.json { render json: @renewal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /renewals/1
  # PATCH/PUT /renewals/1.json
  def update
    respond_to do |format|
      if @renewal.update(renewal_params)
        format.html { redirect_to @renewal, notice: 'Renewal was successfully updated.' }
        format.json { render :show, status: :ok, location: @renewal }
      else
        format.html { render :edit }
        format.json { render json: @renewal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /renewals/1
  # DELETE /renewals/1.json
  def destroy
    @renewal.destroy
    respond_to do |format|
      format.html { redirect_to renewals_url, notice: 'Renewal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def need_renew
    if @renewal.update!(user_id: current_user.id)
      @renewal.need_renew!
      redirect_to single_customers_list_need_renew_path, notice: "客户#{SingleCustomer.find(@renewal.single_customer_id).name}已被置为'服务中-等待续费'状态."
    else
      redirect_to single_customers_list_need_renew_path
    end
  end

  def list_waiting
    @renewals = Renewal.with_waiting_state.page params[:page]
  end

  def finish_renew
    @renewal.finish_renew!
    redirect_to renewals_list_waiting_path, notice: "客户#{SingleCustomer.find(@renewal.single_customer_id).name}已被置为'服务中-无需续费'状态."
  end

  def stop
    @renewal.stop!
    redirect_to renewals_list_waiting_path, notice: "客户#{SingleCustomer.find(@renewal.single_customer_id).name}已被置为'已停服-无需续费'状态."
  end

  def finish_restart
    @renewal.finish_restart!
    redirect_to renewals_list_stopped_path, notice: "客户#{SingleCustomer.find(@renewal.single_customer_id).name}已被重新置为'服务中-无需续费'状态."
  end

  def list_stopped
    @renewals = Renewal.with_stopped_state.page params[:page]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_renewal
      @renewal = Renewal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def renewal_params
      params.require(:renewal).permit(:single_customer_id, :user_id, :workflow_state, :comment)
    end
end
