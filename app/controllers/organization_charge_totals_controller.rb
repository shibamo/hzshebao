class OrganizationChargeTotalsController < ApplicationController
  before_action :set_organization_charge_total, only: [:show, :edit, :update, :destroy, 
                :set_money_arrival_date,:finish_money_check,:leader_check, 
                :set_money_arrival_date_ng, :finish_money_check_ng]
  before_action :set_organization, only: [:list_by_organization, :new, :create,:edit,:show]
  before_action :set_model_class

  # GET /organization_charge_totals
  # GET /organization_charge_totals.json
  def index
    @organization_charge_totals = @model_class.all.page params[:page]
  end

  # GET /organization_charge_totals/1
  # GET /organization_charge_totals/1.json
  def show
    respond_to do |format|
      format.html {} #网页正常显示,使用缺省view template 
      format.json do #导出到json,ajax使用
        render "show.json.jbuilder"
      end
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "单位应付费用表"
        sheet1.row(0).default_format = Spreadsheet::Format.new weight: :bold,size: 12
        sheet1.row(0).push '杭州琳丰人力资源服务有限公司'
        sheet1.row(1).push '单位应付费用表（一）'
        sheet1.row(2).push '单位名称：' + @organization_charge_total.organization.name
        # =>                      0          1        2         3      4       5       6        7         8       9       10       11     12   13
        sheet1.row(3).concat %w{姓名 费用所属日期 缴费基数 企业社保 个人社保 残保 社保管理费 缴费基数 企业公积 个人公积 公积管理费 个税 其它1 其它2 
            其它3 补缴 预缴 应发工资 合计 资金到账日期 资金审核日期 备注}
        # => 14    15    16   17      18      19             20      21
        current_line_number = 4
        @organization_charge_total.organization_charges.each_with_index do |r,i|
          [19,20].each {|col| sheet1.row(i+4).set_format col, default_excel_date_format}
          (2..18).each {|col| sheet1.row(i+4).set_format col, default_excel_money_format}
          sheet1.row(i+4).push r.organization_customer.name, 
            @organization_charge_total.start_date.to_s.tr('-','') + "-" + @organization_charge_total.end_date.to_s.tr('-',''),
            r.price_shebao_base, r.price_shebao_qiye, r.price_shebao_geren, r.price_canbao, r.price_shebao_guanli,
            r.price_gongjijin_base, r.price_gongjijin_qiye, r.price_gongjijin_geren, r.price_gongjijin_guanli, r.price_geshui,
            r.price_qita_1, r.price_qita_2, r.price_qita_3, r.price_bujiao,
            r.price_yujiao, r.price_gongzi,r.price_receivable_total,
            @organization_charge_total.money_arrival_date, @organization_charge_total.money_check_date, 
            r.comment
          current_line_number = current_line_number + 1
        end
        sheet1.row(current_line_number+2).push  '户名：    杭州琳丰人力资源服务有限公司'
        sheet1.row(current_line_number+3).push  '开户行：  交通银行杭州运河支行'
        sheet1.row(current_line_number+4).push  '帐号：    3310659 000 18010056865'
        sheet1.row(current_line_number+5).push  '联系人：  夏敏（财务）、丁元君（申报）'
        sheet1.row(current_line_number+6).push  '联系电话：0571-85836637 13486168670（财务） 0571-87918396（申报）'
        sheet1.row(current_line_number+7).push  '传真：    0571-85836632'
        sheet1.row(current_line_number+8).push  '联系地址：中国杭州拱墅区上塘路619-621号'
        sheet1.row(current_line_number+9).push  '公司邮箱：qfeicc@126.com'
        sheet1.row(current_line_number+10).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        sheet1.row(current_line_number+10).push '备注：    费用请于当月12日前汇于我司账户，以免影响员工社保缴纳,如逾期缴纳，将按0.05%/天计算滞纳金。'

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "单位应付费用表" + @organization_charge_total.start_date.to_s + "至" + 
                                            @organization_charge_total.end_date.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  # GET /organization_charge_totals/new
  def new
    @organization_charge_total = @model_class.new
  end

  # GET /organization_charge_totals/1/edit
  def edit
  end

  # POST /organization_charge_totals
  # POST /organization_charge_totals.json
  def create
    save_success = false
    @model_class.transaction do #主从表需要使用transaction
      @organization_charge_total = @model_class.new(organization_charge_total_params)
      @organization_charge_total.user_id = current_user.id 
      organization_charges = []

      organization_charges_params.reject{|t| t[:deleted]}.each do |t|
        t.delete :deleted  #organization_charges表没有deleted这个字段,不能直接传进Model类的new方法中
        oc = OrganizationCharge.new(t)
        oc.user_id = current_user.id
        oc.start_date = @organization_charge_total.start_date
        oc.end_date = @organization_charge_total.end_date
        oc.organization = @organization_charge_total.organization
        organization_charges.push oc
      end
      @organization_charge_total.organization_charges = organization_charges
      sum_organization_charge_total_fields @organization_charge_total, organization_charges
      save_success = @organization_charge_total.save
      #测试出错回滚
      #save_success = false
      #raise ActiveRecord::RecordNotFound
    end

    respond_to do |format|
      if save_success
        format.html { redirect_to @organization_charge_total, notice: 'Organization charge total was successfully created.' }
        format.json { render :show, status: :created, location: @organization_charge_total }
      else
        format.html { render :new }
        format.json { render json: @organization_charge_total.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_fields(source, destination, field_names)
    field_names.each {|f| source[f] = destination[f]}
  end

  def fill_fields(object, fill_value, field_names)
    field_names.each {|f| object[f] = fill_value}
  end

  # PATCH/PUT /organization_charge_totals/1
  # PATCH/PUT /organization_charge_totals/1.json
  def update
    @organization_charge_total = @model_class.find(params[:organization_charge_total_id])
    @organization_charge_total.user_id = current_user.id
    @organization_charge_total.start_date = params[:organization_charge_total][:start_date]
    @organization_charge_total.end_date = params[:organization_charge_total][:end_date]
    @organization_charge_total.comment = params[:organization_charge_total][:comment]

    organization_charges = []

    save_success = false
    @model_class.transaction do #主从表需要使用transaction
      organization_charges_params.each do |t|
        oc = OrganizationCharge.find(t[:id])
        oc.user_id = current_user.id
        oc.start_date = @organization_charge_total.start_date
        oc.end_date = @organization_charge_total.end_date
        if t[:deleted]
          fill_fields oc, 0, @model_class.price_receivable_list
        else
          copy_fields oc, t, @model_class.price_receivable_list
        end
        organization_charges.push oc
      end
      @organization_charge_total.organization_charges = organization_charges
      sum_organization_charge_total_fields @organization_charge_total, organization_charges
      save_success = @organization_charge_total.save
      #测试出错回滚
      #save_success = false
      #raise ActiveRecord::RecordNotFound
    end
    respond_to do |format|
      if save_success
        format.html { redirect_to @organization_charge_total, notice: 'Organization charge total was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_charge_total }
      else
        format.html { render :edit }
        format.json { render json: @organization_charge_total.errors, status: :unprocessable_entity }
      end
    end
  end

#########################################################################################################
  def list_by_organization #指定机构的缴费历史记录
    @organization_charge_totals = @model_class.of_organization(@organization.id).page params[:page]
  end

  def list_money_arrival_check #需要进行资金核对的机构缴费记录
    @organization_charge_totals = @model_class.with_new_state.page params[:page]
  end

  def list_money_arrival_check_ng #需要进行资金核对的机构缴费记录Angular版
    respond_to do |format|
      format.html {} #返回静态网页,使用缺省view template 
      format.json do #导出到json,ajax使用
        @organization_charge_totals = @model_class.with_new_state
        #TO-DO需要附加是否已有附件上传
        render "list_money_arrival_check_ng.json.jbuilder"
      end
    end
  end

  def set_money_arrival_date #设置资金到账日期
    if params[:organization_charge_total] && params[:organization_charge_total][:money_arrival_date] #posted
      if @organization_charge_total.update(money_arrival_date: params[:organization_charge_total][:money_arrival_date])
        redirect_to  organization_charge_totals_list_money_arrival_check_path, 
                notice: "机构客户 #{@organization_charge_total.organization.abbr} 的常规缴费到账时间已设置."
        return
      end
    else #get
      render layout: "layouts/simple" if params[:simpleMode]
    end
  end

  def set_money_arrival_date_ng #设置资金到账日期Angular版
    #byebug
    if params[:organization_charge_total] && params[:organization_charge_total][:money_arrival_date] #posted
      if @organization_charge_total.update(money_arrival_date: params[:organization_charge_total][:money_arrival_date])
        response.status = 200
        response.abort
        return
      end
    else #get
      render layout: "blank"
    end
  end  

  def finish_money_check #完成资金核对
    unless @organization_charge_total.has_attach
          redirect_to  organization_charge_totals_list_money_arrival_check_path, 
                error: "机构客户 #{@organization_charge_total.organization.abbr} 的常规缴费记录附件尚未上传."
          return
    end
    unless @organization_charge_total.money_arrival_date
      redirect_to  organization_charge_totals_list_money_arrival_check_path, 
                error: "机构客户 #{@organization_charge_total.organization.abbr} 的常规缴费到账时间尚未设置."
          return
    end

    @organization_charge_total.finish_money_check! #同时完成缴费单的资金检查
    @organization_charge_total.update(money_check_date: Date.current) #设置资金审核日期
    redirect_to  organization_charge_totals_list_money_arrival_check_path, 
                notice: "机构客户 #{@organization_charge_total.organization.abbr} 的常规缴费资金已确认到账."
  end

  def finish_money_check_ng #完成资金核对Angular版
    unless @organization_charge_total.has_attach && @organization_charge_total.money_arrival_date
      response.status = 500
      response.abort
      return
    end

    @organization_charge_total.finish_money_check! #同时完成缴费单的资金检查
    @organization_charge_total.update(money_check_date: Date.current) #设置资金审核日期
    render layout: "blank"
  end

  def commission_input_allowed #需要输入提成单的机构缴费记录列表
    @organization_charge_totals = @model_class.with_money_arrived_state.
                                        managed_by_users(current_user.id).page params[:page]
  end

  def list_leader_check #需要进行领导最终审核的机构缴费记录列表
    @organization_charge_totals = @model_class.with_commission_finished_state.page params[:page]
  end

  def leader_check #完成领导最终审核
    @organization_charge_total.finish_leader_check!
    redirect_to organization_charge_totals_list_leader_check_path, 
                notice: "机构客户 #{@organization_charge_total.organization.name} 的常规缴费记录已审核通过."
  end

  def list_total #机构常规缴费单所有(html)与Excel导出(仅限到账日期与审核日期的区间查询条件)
    respond_to do |format|
      format.html { @organization_charge_totals = @model_class.all.page params[:page]} #网页正常显示
      format.xls do #导出到excel

        @money_arrival_date_from = params[:money_arrival_date_from] if params[:money_arrival_date_from]
        @money_arrival_date_to = params[:money_arrival_date_to] if params[:money_arrival_date_to]
        @money_check_date_from = params[:money_check_date_from] if params[:money_check_date_from]
        @money_check_date_to = params[:money_check_date_to] if params[:money_check_date_to]
        
        if @money_check_date_from && @money_check_date_to
          @organization_charge_totals = @model_class.where("money_check_date >= :money_check_date_from and money_check_date <=:money_check_date_to",
            money_check_date_from: @money_check_date_from, money_check_date_to: Date.parse(@money_check_date_to))
        else
          @organization_charge_totals = @model_class.all
        end

        if @money_arrival_date_from && @money_arrival_date_to
          @organization_charge_totals = @organization_charge_totals.where("money_arrival_date >= :money_arrival_date_from and money_arrival_date <=:money_arrival_date_to",
            money_arrival_date_from: @money_arrival_date_from, money_arrival_date_to: Date.parse(@money_arrival_date_to))
        end

        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "机构常规缴费记录表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0          1        2         3    4       5         6        7         8       9     10    11    12   13   14    15      16 
        sheet1.row(0).concat %w{内部序号 机构名称 企业社保 个人社保 残保 社保管理费 企业公积 个人公积 公积管理费 个税 其它1 其它2 其它3 补缴 预缴 应发工资 合计
          服务起始 服务结束 资金到账日期 资金审核日期 状态 业务员}
        # => 17        18      19             20       21    22
        @organization_charge_totals.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.organization.name,  
                              r.price_shebao_qiye, r.price_shebao_geren, r.price_canbao, r.price_shebao_guanli,
                              r.price_gongjijin_qiye, r.price_gongjijin_geren, r.price_gongjijin_guanli, r.price_geshui,
                              r.price_qita_1, r.price_qita_2, r.price_qita_3, r.price_bujiao,
                              r.price_yujiao, r.price_gongzi,r.price_receivable_total,
                              r.start_date, r.end_date,r.money_arrival_date, r.money_check_date, 
                              r.translate_workflow_state_name(@model_class::WORKFLOW_STATE_NAMES).to_s, r.user.name
          [17,18,19,20].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "机构常规缴费记录表" + Date.today.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  #query函数此处实现主要用了where chaining, 根据
  #http://stackoverflow.com/questions/11702341/lazy-loading-in-rails-3-2-6, 将只会在最后产生一次查询,无性能影响.
  def query 
    redirect_to organization_charge_totals_list_total_url and return unless params[:organization_charge_total]

    @organization_charge_total = @model_class.new(organization_charge_total_params)
    @organization_customer_name = params[:organization_charge_total][:organization_customer_name]
    @money_arrival_date_from = params[:organization_charge_total][:money_arrival_date_from]
    @money_arrival_date_to = params[:organization_charge_total][:money_arrival_date_to]
    @money_check_date_from = params[:organization_charge_total][:money_check_date_from]
    @money_check_date_to = params[:organization_charge_total][:money_check_date_to]
    
    if @organization_customer_name.length > 0
      results ||= @model_class.all
      results = results.of_customer_name_like(@organization_customer_name)
    end

    if @organization_charge_total.user_id && @organization_charge_total.user_id >0
      results ||= @model_class.all
      results = results.managed_by_users([@organization_charge_total.user_id])
    end

    if @organization_charge_total.workflow_state && @organization_charge_total.workflow_state.length > 0
      results ||= @model_class.all
      results = results.of_workflow_state(@organization_charge_total.workflow_state)
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
    @organization_charge_totals = results.page params[:page]

    render :list_total
  end

  def table_ng
    render layout: "blank"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_charge_total
      if params[:id]
        @organization_charge_total = OrganizationChargeTotal.find(params[:id])
      end
    end

    def set_model_class
      @model_class = OrganizationChargeTotal
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

    #接收机构员工缴费对象数组
    def organization_charges_params
      params.require(:organization_charges).map do |t|
        t.permit(:id, :organization_customer_id, :price_shebao_base, :price_shebao_qiye, 
        :price_shebao_geren, :price_canbao, :price_shebao_guanli, 
        :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, 
        :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, 
        :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :deleted)
      end
    end

    #设置机构
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

    #根据机构员工缴费明细数据汇总计算机构应付的各个项目金额
    def sum_organization_charge_total_fields(organization_charge_total, organization_charges)
      organization_charge_total.price_shebao_base = sum_array_field(organization_charges,:price_shebao_base)
      organization_charge_total.price_shebao_qiye = sum_array_field(organization_charges,:price_shebao_qiye)
      organization_charge_total.price_shebao_geren = sum_array_field(organization_charges,:price_shebao_geren)
      organization_charge_total.price_canbao = sum_array_field(organization_charges,:price_canbao)
      organization_charge_total.price_shebao_guanli = sum_array_field(organization_charges,:price_shebao_guanli)
      organization_charge_total.price_gongjijin_base = sum_array_field(organization_charges,:price_gongjijin_base)
      organization_charge_total.price_gongjijin_qiye = sum_array_field(organization_charges,:price_gongjijin_qiye)
      organization_charge_total.price_gongjijin_geren = sum_array_field(organization_charges,:price_gongjijin_geren)
      organization_charge_total.price_gongjijin_guanli = sum_array_field(organization_charges,:price_gongjijin_guanli)
      organization_charge_total.price_geshui = sum_array_field(organization_charges,:price_geshui)
      organization_charge_total.price_qita_1 = sum_array_field(organization_charges,:price_qita_1)
      organization_charge_total.price_qita_2 = sum_array_field(organization_charges,:price_qita_2)
      organization_charge_total.price_qita_3 = sum_array_field(organization_charges,:price_qita_3)
      organization_charge_total.price_bujiao = sum_array_field(organization_charges,:price_bujiao)
      organization_charge_total.price_yujiao = sum_array_field(organization_charges,:price_yujiao)
      organization_charge_total.price_gongzi = sum_array_field(organization_charges,:price_gongzi)
    end

    #计算字典数组的指定字段的和
    def sum_array_field(array, fieldName)
      array.reduce(0){|memo,obj| memo + obj[fieldName]}
    end

    #所有的价格费用字段排序
    def price_fields
      return [:price_shebao_base, :price_shebao_qiye, 
        :price_shebao_geren, :price_canbao, :price_shebao_guanli, 
        :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, 
        :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, 
        :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi]
    end
end