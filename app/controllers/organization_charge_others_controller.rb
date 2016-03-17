class OrganizationChargeOthersController < ApplicationController
  before_action :set_organization_charge_other, only: [:show, :edit, :update, :destroy, 
                :set_money_arrival_date,:finish_money_check,:leader_check]
  before_action :set_organization, only: [:list_by_organization, :new, :create,:edit,:show,:update]
  before_action :set_model_class

  # GET /organization_charge_others
  # GET /organization_charge_others.json
  def index
    @organization_charge_others = @model_class.all.page params[:page]
  end

  # GET /organization_charge_others/1
  # GET /organization_charge_others/1.json
  def show
  end

  # GET /organization_charge_others/new
  def new
    @organization_charge_other = @model_class.new
    #新建时需事先指定所属的机构
    @organization_charge_other.organization = @organization
    #新建时预设所有收费字段为0
    @organization_charge_other.batch_set_nil_property_value(0, *@model_class.price_receivable_list)
  end

  # GET /organization_charge_others/1/edit
  def edit
  end

  # POST /organization_charge_others
  # POST /organization_charge_others.json
  def create
    @organization_charge_other = @model_class.new(organization_charge_other_params)
    @organization_charge_other.user_id = current_user.id
    #收费字段如果为空则设置为0
    @organization_charge_other.batch_set_nil_property_value(0, *@model_class.price_receivable_list)

    respond_to do |format|
      if @organization_charge_other.save
        format.html { redirect_to organization_charge_others_list_by_organization_path(@organization), notice: '成功创建机构其他缴费单.' }
        format.json { render :show, status: :created, location: @organization_charge_other }
      else
        format.html { render :new }
        format.json { render json: @organization_charge_other.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_charge_others/1
  # PATCH/PUT /organization_charge_others/1.json
  def update
    respond_to do |format|
      if @organization_charge_other.update(organization_charge_other_params)
        @organization_charge_other.batch_set_nil_property_value(0, *@model_class.price_receivable_list)
        @organization_charge_other.save
        format.html { redirect_to organization_charge_others_list_by_organization_path(@organization), notice: '机构其他缴费单已成功修改.' }
        format.json { render :show, status: :ok, location: @organization_charge_other }
      else
        format.html { render :edit }
        format.json { render json: @organization_charge_other.errors, status: :unprocessable_entity }
      end
    end
  end

#########################################################################################################
  def list_by_organization #指定机构的缴费历史记录
    @organization_charge_others = @model_class.of_organization(@organization.id).page params[:page]
  end

  def list_money_arrival_check #需要进行资金核对的机构缴费记录
    @organization_charge_others = @model_class.with_new_state.page params[:page]
  end

  def set_money_arrival_date #设置资金到账日期
    if params[:organization_charge_other] && params[:organization_charge_other][:money_arrival_date] #posted
      if @organization_charge_other.update(money_arrival_date: params[:organization_charge_other][:money_arrival_date])
        redirect_to  organization_charge_others_list_money_arrival_check_path, 
                notice: "机构客户 #{@organization_charge_other.organization.abbr} 的其他缴费到账时间已设置."
        return
      end
    else #get
      #
    end
  end

  def finish_money_check #完成资金核对
    if MoneyArrivalFile.where(business_type: "OrganizationChargeOther", main_object_id: @organization_charge_other.id).pluck(:id).count <= 0
          redirect_to  organization_charge_others_list_money_arrival_check_path, 
                error: "机构客户 #{@organization_charge_other.organization.abbr} 的其他缴费记录附件尚未上传."
          return
    end
    unless @organization_charge_other.money_arrival_date
      redirect_to  organization_charge_others_list_money_arrival_check_path, 
                error: "机构客户 #{@organization_charge_other.organization.abbr} 的其他缴费到账时间尚未设置."
      return
    end

    @organization_charge_other.finish_money_check! #同时完成缴费单的资金检查
    @organization_charge_other.update(money_check_date: Date.current) #设置资金审核日期
    redirect_to  organization_charge_others_list_money_arrival_check_path, 
                notice: "机构客户 #{@organization_charge_other.organization.abbr} 的其他缴费资金已确认到账."
  end

  def commission_input_allowed #需要输入提成单的机构缴费记录列表
    @organization_charge_others = @model_class.with_money_arrived_state.managed_by_users(current_user.id).page params[:page]
  end

  def list_leader_check #需要进行领导最终审核的机构缴费记录列表
    @organization_charge_others = @model_class.with_commission_finished_state.page params[:page]
  end

  def leader_check #完成领导最终审核
    @organization_charge_other.finish_leader_check!
    redirect_to organization_charge_others_list_leader_check_path, 
                notice: "机构客户 #{@organization_charge_other.organization.name} 的其他缴费记录已审核通过."
  end

  def list_total #机构其他缴费单所有(html)与Excel导出(仅限到账日期与审核日期的区间查询条件)
    respond_to do |format|
      format.html { @organization_charge_others = @model_class.all.page params[:page]} #网页正常显示
      format.xls do #导出到excel

        @money_arrival_date_from = params[:money_arrival_date_from] if params[:money_arrival_date_from]
        @money_arrival_date_to = params[:money_arrival_date_to] if params[:money_arrival_date_to]
        @money_check_date_from = params[:money_check_date_from] if params[:money_check_date_from]
        @money_check_date_to = params[:money_check_date_to] if params[:money_check_date_to]
        
        if @money_check_date_from && @money_check_date_to
          @organization_charge_others = @model_class.where("money_check_date >= :money_check_date_from and money_check_date <=:money_check_date_to",
            money_check_date_from: @money_check_date_from, money_check_date_to: Date.parse(@money_check_date_to))
        else
          @organization_charge_others = @model_class.all
        end

        if @money_arrival_date_from && @money_arrival_date_to
          @organization_charge_others = @organization_charge_others.where("money_arrival_date >= :money_arrival_date_from and money_arrival_date <=:money_arrival_date_to",
            money_arrival_date_from: @money_arrival_date_from, money_arrival_date_to: Date.parse(@money_arrival_date_to))
        end

        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "机构其他缴费记录表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12

        # =>                      0          1        2    3      4    5      6     7     8     9       10          11        12   13
        sheet1.row(0).concat %w{内部序号 机构名称 服务费 残保金 差价 工会费 其它1 其它2 其它3 合计 资金到账日期 资金审核日期 状态 业务员}
        @organization_charge_others.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.organization.name,  
                              r.price_fuwufei, r.price_canbao, r.price_chajia, r.price_gonghui,
                              r.price_qita_1, r.price_qita_2, r.price_qita_3, r.price_receivable_total,
                              r.money_arrival_date, r.money_check_date, 
                              r.translate_workflow_state_name(@model_class::WORKFLOW_STATE_NAMES).to_s, r.user.name
          [10,11].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "机构其他缴费记录表" + Date.today.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  #query函数此处实现主要用了where chaining, 根据
  #http://stackoverflow.com/questions/11702341/lazy-loading-in-rails-3-2-6, 将只会在最后产生一次查询,无性能影响.
  def query 
    redirect_to organization_charge_others_list_total_url and return unless params[:organization_charge_other]

    @organization_charge_other = @model_class.new(organization_charge_other_params)
    @organization_customer_name = params[:organization_charge_other][:organization_customer_name]
    @money_arrival_date_from = params[:organization_charge_other][:money_arrival_date_from]
    @money_arrival_date_to = params[:organization_charge_other][:money_arrival_date_to]
    @money_check_date_from = params[:organization_charge_other][:money_check_date_from]
    @money_check_date_to = params[:organization_charge_other][:money_check_date_to]
    
    if @organization_customer_name.length > 0
      results ||= @model_class.all
      results = results.of_customer_name_like(@organization_customer_name)
    end

    if @organization_charge_other.user_id && @organization_charge_other.user_id >0
      results ||= @model_class.all
      results = results.managed_by_users([@organization_charge_other.user_id])
    end

    if @organization_charge_other.workflow_state && @organization_charge_other.workflow_state.length > 0
      results ||= @model_class.all
      results = results.of_workflow_state(@organization_charge_other.workflow_state)
    end

    if @money_arrival_date_from.length>0
      results ||= @model_class.all
      results = results.of_money_arrival_date_from(@money_arrival_date_from)
    end

    if @money_arrival_date_to.length>0
      results ||= @model_class.all
      results = results.of_money_arrival_date_to(@money_arrival_date_to)
    end

    if @money_check_date_from.length>0
      results ||= @model_class.all
      results = results.of_money_check_date_from(@money_check_date_from)
    end

    if @money_check_date_to.length>0
      results ||= @model_class.all
      results = results.of_money_check_date_to(@money_check_date_to)
    end

    results ||= @model_class.all
    @organization_charge_others = results.page params[:page]

    render :list_total
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_charge_other
      @organization_charge_other = OrganizationChargeOther.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_charge_other_params
      params.require(:organization_charge_other).permit(:organization_id, :user_id, :price_fuwufei, :price_canbao, :price_chajia, :price_gonghui, :price_qita_1, :price_qita_2, :price_qita_3, :start_date, :end_date, :comment, :money_arrival_date, :money_check_date, :workflow_state)
    end

    def set_model_class
      @model_class = OrganizationChargeOther
    end

    #设置机构
    def set_organization
      if @organization_charge_other
        @organization = @organization_charge_other.organization
        return
      end
      if params[:organization_id]
        @organization = Organization.find(params[:organization_id])
        return
      end
      if params[:organization_charge_other] && params[:organization_charge_other][:organization_id]
        @organization = Organization.find(params[:organization_charge_other][:organization_id])
      end
    end
end
