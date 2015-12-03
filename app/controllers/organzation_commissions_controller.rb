class OrganzationCommissionsController < ApplicationController
  before_action :set_organzation_commission, only: [:show, :edit, :update, :approve, 
                                        :finance_check, :set_user, :update_user]
  before_action :set_organization_charge_total, only: [:new, :create, :edit, :update]

  # GET /organzation_commissions
  # GET /organzation_commissions.json
  def index
    @organzation_commissions = OrganzationCommission.all.page params[:page]
  end

  # GET /organzation_commissions/1
  # GET /organzation_commissions/1.json
  def show
  end

  # GET /organzation_commissions/new
  def new
    @organzation_commission = OrganzationCommission.new(
      commission_no: @organization_charge_total.abbr + Time.current.strftime("%Y%m%d%H%M%S"))
    #此处机构收费提成单号的生成规则与个人收费提成单号规则不一样,取 "机构简称"+时间戳
  end

  # GET /organzation_commissions/1/edit
  def edit
  end

  # POST /organzation_commissions
  # POST /organzation_commissions.json
  def create
    @organzation_commission = OrganzationCommission.new(organzation_commission_params)
    @organzation_commission.organization_charge_total = @organization_charge_total
    @commission.user_id = session["current_user_id"]

    respond_to do |format|
      if @organzation_commission.save
        @organization_charge_total.finish_commission_form! #设置机构收费单为提成单已完成状态,工作流继续
        format.html { redirect_to @organzation_commission, notice: '机构提成单已成功提交.' }
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
        format.html do
          if @organzation_commission.workflow_state == "approved" #转回财务审批
            redirect_to organzation_commissions_need_finance_check_path, notice: '机构提成单已成功修改.' 
            return
          else #转回公司管理->提成单查询
            redirect_to organzation_commissions_list_total_path, notice: '机构提成单已成功修改.' 
            return
          end
        end
        format.json { render :show, status: :ok, location: @organzation_commission }
      else
        format.html { render :edit }
        format.json { render json: @organzation_commission.errors, status: :unprocessable_entity }
      end
    end
  end

#############################################################################################################
  def need_approve #待审批列表
    @organzation_commissions = OrganzationCommission.with_new_state.page params[:page]
  end

  def approve #审批操作
    @organzation_commission.finish_approve!(session["current_user_id"])
    redirect_to organzation_commissions_need_approve_path, notice: "编号为#{@organzation_commission.commission_no}的机构提成单已审批." 
  end

  def need_finance_check #待财务审核列表
    @organzation_commissions = OrganzationCommission.with_approved_state.page params[:page]
  end

  def finance_check #财务审核
    @organzation_commission.finish_finance_check!(session["current_user_id"])
    redirect_to organzation_commissions_need_finance_check_path, notice: "编号为#{@organzation_commission.commission_no}的机构提成单已财务审核通过." 
  end

  def list_total #提成单查询
    respond_to do |format|
      if params[:organzation_commission] && params[:organzation_commission][:input_date_from].length>0 && params[:organzation_commission][:input_date_to].length>0
        @input_date_from = params[:organzation_commission][:input_date_from] if params[:organzation_commission][:input_date_from]
        @input_date_to = params[:organzation_commission][:input_date_to] if params[:organzation_commission][:input_date_to]
      end
      
      if params[:organzation_commission] && params[:organzation_commission][:organzation_customer_name].length>0
        @organzation_customer_name = params[:organzation_commission][:organzation_customer_name]
      end
      
      if @input_date_from && @input_date_to
        @organization_charge_totals = OrganizationChargeTotal.where("money_arrival_date >= :input_date_from and money_arrival_date <=:input_date_to",
            input_date_from: @input_date_from, input_date_to: @input_date_to)

        @organzation_commissions = OrganizationCommission.where(organization_charge_total_id: @organization_charge_totals.collect(&:id))
      else
        @organzation_commissions = OrganizationCommission.all
        @input_date_from = @input_date_to = nil
      end

      if @organzation_customer_name
        organization_charge_total_ids = OrganizationChargeTotal.of_customer_name_like(@organzation_customer_name).collect(&:id)
        @organzation_commissions = @organzation_commissions.where('organization_charge_total_id in (?)',organization_charge_total_ids)
      end

      format.html { @organzation_commissions = @organzation_commissions.page params[:page]} #网页正常显示
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "机构收费提成单记录表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12

        # =>                      0          1         2       3       4          5         6    7
        sheet1.row(0).concat %w{内部序号 机构客户名 业务员 收款金额 计奖金额 资金到账日期 奖金 状态}
        @input_date_from = params[:input_date_from] if params[:input_date_from]
        @input_date_to = params[:input_date_to] if params[:input_date_to]
        if @input_date_from && @input_date_to
          @charges = OrganizationChargeTotal.where("money_arrival_date >= :input_date_from and money_arrival_date <=:input_date_to",
            input_date_from: @input_date_from, input_date_to: @input_date_to)
          @organzation_commissions = OrganizationCommission.where(charge_id: @charges.collect(&:id))
        else
          @organzation_commissions = OrganizationCommission.all
        end
        @organzation_commissions.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.organization_charge_total.organization_customer.name, r.user.name, 
                              r.organization_charge_total.price_receivable_total, r.bonus_reference,
                              r.organization_charge_total.money_arrival_date, r.bonus,
                              r.translate_workflow_state_name(OrganizationCommission::WORKFLOW_STATE_NAMES).to_s
          [12].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "机构日常缴费提成单记录表" + Date.today.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def set_user
  end

  def update_user
    if @organzation_commission.update(user: User.find(params[:organzation_commission][:user_id]))
      redirect_to organzation_commissions_need_approve_path , notice: "该提成单的业务员已成功更改为#{User.find(params[:organzation_commission][:user_id]).name}."
    else
      render :set_user 
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
