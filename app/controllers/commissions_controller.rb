class CommissionsController < ApplicationController
  before_action :set_commission, only: [:show, :edit, :update, :destroy, :approve, 
                                        :finance_check, :set_user, :update_user]
  before_action :set_charge, only: [:new, :create, :edit, :update]

  # GET /commissions
  # GET /commissions.json
  def index
    @commissions = Commission.all.page params[:page]
  end

  # GET /commissions/1
  # GET /commissions/1.json
  def show
  end

  # GET /commissions/new
  def new
    @commission = Commission.new(commission_no: @charge.document_no.to_s)
  end

  # GET /commissions/1/edit
  def edit
  end

  # POST /commissions
  # POST /commissions.json
  def create
    @commission = Commission.new(commission_params)
    @commission.charge = @charge
    @commission.user_id = session["current_user_id"]

    respond_to do |format|
      if @commission.save
        @charge.finish_commission_form!
        format.html { redirect_to charges_for_commission_input_allowed_path, notice: '提成单已成功提交.' }
        format.json { render :show, status: :created, location: @commission }
      else
        format.html { render :new }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commissions/1
  # PATCH/PUT /commissions/1.json
  def update
    respond_to do |format|
      if @commission.update(commission_params)
        format.html { redirect_to commissions_need_finance_check_path, notice: '提成单已成功修改.' }
        format.json { render :show, status: :ok, location: @commission }
      else
        format.html { render :edit }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commissions/1
  # DELETE /commissions/1.json
  def destroy
    @commission.destroy
    respond_to do |format|
      format.html { redirect_to commissions_url, notice: 'Commission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def need_approve
    @commissions = Commission.with_new_state.page params[:page]
  end

  def approve
    @commission.finish_approve!(session["current_user_id"])
    redirect_to commissions_need_approve_path, notice: "编号为#{@commission.commission_no}的提成单已审批." 
  end

  def need_finance_check
    @commissions = Commission.with_approved_state.page params[:page]
  end

  def finance_check
    @commission.finish_finance_check!(session["current_user_id"])
    redirect_to commissions_need_finance_check_path, notice: "编号为#{@commission.commission_no}的提成单已财务审核通过." 
  end

  def list_total #提成单查询
    respond_to do |format|
      if params[:commission] && params[:commission][:input_date_from].length>0 && params[:commission][:input_date_to].length>0
        @input_date_from = params[:commission][:input_date_from] if params[:commission][:input_date_from]
        @input_date_to = params[:commission][:input_date_to] if params[:commission][:input_date_to]
      end
      
      if @input_date_from && @input_date_to
        @charges = Charge.where("money_arrival_date >= :input_date_from and money_arrival_date <=:input_date_to",
            input_date_from: @input_date_from, input_date_to: @input_date_to)

        @commissions = Commission.where(charge_id: @charges.collect(&:id))
      else
        @commissions = Commission.all
        @input_date_from = @input_date_to = nil
      end

      format.html { @commissions = @commissions.page params[:page]} #网页正常显示
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "提成单记录表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12

        # =>                      0          1        2       3       4       5     6      7      8     9     10   11     12      13       14       15
        sheet1.row(0).concat %w{内部序号 客户姓名   业务员 收款类型 社保费 公积金 服务费 材料费 补交费 差价  个税 总计 计奖金额  奖金 资金到账日期 状态 }
        @input_date_from = params[:input_date_from] if params[:input_date_from]
        @input_date_to = params[:input_date_to] if params[:input_date_to]
        if @input_date_from && @input_date_to
          @charges = Charge.where("money_arrival_date >= :input_date_from and money_arrival_date <=:input_date_to",
            input_date_from: @input_date_from, input_date_to: @input_date_to)
          @commissions = Commission.where(charge_id: @charges.collect(&:id))
        else
          @commissions = Commission.all
        end
        @commissions.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.charge.single_customer.name, r.user.name, r.charge.charge_type, 
                              r.charge.price_shebao*r.charge.months_shebao, 
                              r.charge.price_gongjijin*r.charge.months_gongjijin, r.charge.price_fuwufei*r.charge.months_fuwufei, 
                              r.charge.price_cailiaofei*r.charge.months_cailiaofei, r.charge.price_bujiao*r.charge.months_bujiao,
                              r.charge.price_chajia*r.charge.months_chajia, r.charge.price_geshui*r.charge.months_geshui,
                              r.charge.money_total, r.bonus_reference,r.bonus, r.charge.money_arrival_date,
                              r.translate_workflow_state_name(Commission::WORKFLOW_STATE_NAMES).to_s
          [12].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "提成单记录表" + Date.today.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def set_user
  end

  def update_user
    if @commission.update(user: User.find(params[:commission][:user_id]))
      redirect_to commissions_need_approve_path , notice: "该提成单的业务员已成功更改为#{User.find(params[:commission][:user_id]).name}."
    else
      render :set_user 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commission
      @commission = params[:id] ? Commission.find(params[:id]) : Commission.find(params[:commission_id])
    end

    def set_charge
      @charge = Charge.find(params[:charge_id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def commission_params
      params.require(:commission).permit(:commission_no, :charge_id, :user_id, :bonus_reference, :bonus, :approver_id, :financer_id, :workflow_state_string)
    end
end
