class OrganizationCommissionOthersController < ApplicationController
  before_action :set_model_class
  before_action :set_organization_commission_other, only: [:show, :edit, :update, :approve, 
                                        :finance_check, :set_user, :update_user]
  before_action :set_organization_charge_other, only: [:new, :create]

  # GET /organization_commission_others
  # GET /organization_commission_others.json
  def index
    @organization_commission_others = @model_class.all.page params[:page]
  end

  # GET /organization_commission_others/1
  # GET /organization_commission_others/1.json
  def show
  end

  # GET /organization_commission_others/new
  def new
    @organization_commission_other = @model_class.new(
      commission_no: @organization_charge_other.organization.abbr + Time.current.strftime("%Y%m%d%H%M%S"))
  end

  # GET /organization_commission_others/1/edit
  def edit
  end

  # POST /organization_commission_others
  # POST /organization_commission_others.json
  def create
    @organization_commission_other = @model_class.new(organization_commission_other_params)
    @organization_commission_other.organization_charge_other = @organization_charge_other
    @organization_commission_other.user_id = session["current_user_id"]

    respond_to do |format|
      if @organization_commission_other.save
        @organization_charge_other.finish_commission_form! #设置机构收费单为提成单已完成状态,工作流推进
        format.html { redirect_to organization_charge_others_commission_input_allowed_path, notice: '机构其他收费提成单已成功提交.' }
        format.json { render :show, status: :created, location: @organization_commission_other }
      else
        format.html { render :new }
        format.json { render json: @organization_commission_other.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_commission_others/1
  # PATCH/PUT /organization_commission_others/1.json
  def update
    respond_to do |format|
      if @organization_commission_other.update(organization_commission_other_params)
        format.html do
          if @organization_commission_other.workflow_state == "approved" #转回财务审批
            redirect_to organzation_commission_others_need_finance_check_path, notice: '机构其他提成单已成功修改.' 
            return
          else #转回公司管理->提成单查询
            redirect_to organzation_commission_others_list_total_path, notice: '机构其他提成单已成功修改.' 
            return
          end
        end
        format.json { render :show, status: :ok, location: @organization_commission_other }
      else
        format.html { render :edit }
        format.json { render json: @organization_commission_other.errors, status: :unprocessable_entity }
      end
    end
  end

#############################################################################################################
  def need_approve #待审批列表
    @organization_commission_others = @model_class.with_new_state.page params[:page]
  end

  def approve #审批操作
    @organization_commission_other.finish_approve!(session["current_user_id"])
    redirect_to organzation_commission_others_need_approve_path, notice: "编号为#{@organization_commission_other.commission_no}的机构其他提成单已审批." 
  end

  def need_finance_check #待财务审核列表
    @organization_commission_others = @model_class.with_approved_state.page params[:page]
  end

  def finance_check #财务审核
    @organization_commission_other.finish_finance_check!(session["current_user_id"])
    redirect_to organzation_commissions_need_finance_check_path, notice: "编号为#{@organization_commission_other.commission_no}的机构其他提成单已财务审核通过." 
  end

  def list_total #提成单查询
    respond_to do |format|
      if params[:organzation_commission_other] && params[:organzation_commission_other][:input_date_from].length>0 && 
          params[:organzation_commission_other][:input_date_to].length>0
        @input_date_from = params[:organzation_commission_other][:input_date_from] if params[:organzation_commission_other][:input_date_from]
        @input_date_to = params[:organzation_commission_other][:input_date_to] if params[:organzation_commission_other][:input_date_to]
      end
      
      if params[:organzation_commission_other] && params[:organzation_commission_other][:organzation_customer_name].length>0
        @organzation_customer_name = params[:organzation_commission_other][:organzation_customer_name]
      end
      
      if @input_date_from && @input_date_to
        @organization_charge_others = @model_class.where("money_arrival_date >= :input_date_from and money_arrival_date <=:input_date_to",
            input_date_from: @input_date_from, input_date_to: @input_date_to)

        @organization_commission_others = @model_class.where(organization_charge_total_id: @organization_charge_others.collect(&:id))
      else
        @organization_commission_others = @model_class.all
        @input_date_from = @input_date_to = nil
      end

      if @organzation_customer_name
        organization_charge_other_ids = @model_class.of_customer_name_like(@organzation_customer_name).collect(&:id)
        @organization_commission_others = @organization_commission_others.where('organization_charge_other_id in (?)',organization_charge_other_ids)
      end

      format.html { @organization_commission_others = @organization_commission_others.page params[:page]} #网页正常显示
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "机构收费其他提成单记录表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12

        # =>                      0          1         2       3       4          5         6    7
        sheet1.row(0).concat %w{内部序号 机构客户名 业务员 收款金额 计奖金额 资金到账日期 奖金 状态}
        @input_date_from = params[:input_date_from] if params[:input_date_from]
        @input_date_to = params[:input_date_to] if params[:input_date_to]
        if @input_date_from && @input_date_to
          octs = @model_class.where("money_arrival_date >= :input_date_from and money_arrival_date <=:input_date_to",
            input_date_from: @input_date_from, input_date_to: @input_date_to)
          @organization_commission_others = @model_class.where(organization_charge_total_id: octs.collect(&:id))
        else
          @organization_commission_others = @model_class.all
        end
        @organization_commission_others.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.organization_charge_other.organization.name, r.user.name, 
                              r.organization_charge_other.price_receivable_other, r.bonus_reference,
                              r.organization_charge_other.money_arrival_date, r.bonus,
                              r.translate_workflow_state_name(@model_class::WORKFLOW_STATE_NAMES).to_s
          [5].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "机构其他缴费提成单记录表" + Date.today.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def set_user
    if params[:organzation_commission_other] && params[:organzation_commission_other][:user_id] && 
      @organization_commission_other.update(user: User.find(params[:organzation_commission_other][:user_id]))
      redirect_to organzation_commission_others_need_approve_path , 
        notice: "该提成单的业务员已成功更改为#{User.find(params[:organzation_commission_other][:user_id]).name}."
      return 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_commission_other
      @organization_commission_other = OrganizationCommissionOther.find(params[:id])
    end

    def set_model_class
      @model_class = OrganizationCommissionOther
    end

    def set_organization_charge_other #设置对应所属的其他机构收费记录对象
      @organization_charge_other = OrganizationChargeOther.find(params[:organization_charge_other_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_commission_other_params
      params.require(:organization_commission_other).permit(:organization_charge_other_id, :commission_no, :user_id, :bonus_reference, :bonus, :approver_id, :financer_id, :workflow_state)
    end
end
