class SingleCustomersController < ApplicationController
  before_action :authenticate
  before_action :set_single_customer, only: [:show, :edit, :update, :destroy, :set_user, :update_user, 
                                            :finish_check, :finish_apply_start,:finish_apply_stop,:finish_apply_restart]
  before_action :set_users, only: [:index, :query, :list_total]
  
  require 'stringio'

  # GET /single_customers
  # GET /single_customers.json
  def index
    @single_customers = SingleCustomer.managed_by_users(current_user.direct_subordinates_with_self.collect(&:id)).page params[:page]
  end

  # GET /single_customers/1
  # GET /single_customers/1.json
  def show
    render :show, layout: "simple"
  end

  # GET /single_customers/new
  def new
    @single_customer = SingleCustomer.new(ethnic_name: "汉族" )
  end

  # GET /single_customers/1/edit
  def edit
  end

  # POST /single_customers
  # POST /single_customers.json
  def create
    @single_customer = SingleCustomer.new(single_customer_params)
    @single_customer.user_id = session[:current_user_id]

    respond_to do |format|
      if @single_customer.save
        format.html { redirect_to @single_customer, notice: '客户的资料记录已成功创建.' }
        format.json { render :show, status: :created, location: @single_customer }
      else
        format.html { render :new }
        format.json { render json: @single_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /single_customers/1
  # PATCH/PUT /single_customers/1.json
  def update
    respond_to do |format|
      if @single_customer.update(single_customer_params)
        format.html { redirect_to @single_customer, notice: '客户的资料记录已成功修改.' }
        format.json { render :show, status: :ok, location: @single_customer }
      else
        format.html { render :edit }
        format.json { render json: @single_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /single_customers/1
  # DELETE /single_customers/1.json
  def destroy
    @single_customer.destroy
    respond_to do |format|
      format.html { redirect_to single_customers_url, notice: 'Single customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_set_user
    if params[:single_customer] && params[:single_customer][:name]
      @single_customers = SingleCustomer.by_partial_name(params[:single_customer][:name]).page params[:page]
      @single_customer = SingleCustomer.new(single_customer_params)
    else
      @single_customers = SingleCustomer.order_by_users.page params[:page]
    end


    #@single_customer = SingleCustomer.new(single_customer_params)
    #@single_customers = SingleCustomer.order_by_users.page params[:page]

  end

  def set_user
  end

  def update_user
    if @single_customer.update(user: User.find(params[:single_customer][:user_id]))
      redirect_to single_customers_list_set_user_path , notice: "该客户的业务员已成功更改为#{User.find(params[:single_customer][:user_id]).name}."
    else
      render :set_user 
    end
  end

  def list_check
    @single_customers = SingleCustomer.with_new_state.page params[:page]
  end

  def finish_check
    @single_customer.finish_check!
    #客户资料审核通过后马上创建公积金状态记录,即使目前可能不开通公积金服务
    @gongjijin = Gongjijin.create(single_customer_id: @single_customer.id) 
    redirect_to single_customers_list_check_path, 
                notice: "个人客户 #{@single_customer.name} 的资料已审核通过."
  end

  def list_apply_start
    respond_to do |format|
      format.html { @single_customers = SingleCustomer.need_start_shebao.page params[:page] } #网页正常显示
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "Sheet1"
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0          1    2     3             4        5         6         7         8    9     10        11  
        sheet1.row(0).concat %w{身份证号码 姓名 性别 参加工作日期 月工资收入 新增原因 用工形式 户口性质 通迅地址 邮编 手机号码 电子邮箱
 }
        i=1
        SingleCustomer.need_start_shebao.each do |r|
          sheet1.row(i).push r.id_no, r.name, r.gender, (r.shebao_start_date.year*100 + r.shebao_start_date.month), 
                              0.00, 91101, "01", r.hukou_type, r.communication_address, 310000, r.tel, r.email
          i = i+1
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "企业76252报盘批量参保.xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def finish_apply_start
    if MoneyArrivalFile.business_files("SingleCustomer",@single_customer.id, 
        @single_customer.updated_at.to_s, "finish_apply_start").count <= 0
      redirect_to single_customers_list_apply_start_path, 
                error: "操作失败, 个人客户 #{@single_customer.name} 的申报操作文件尚未上传."
      return
    end
    @single_customer.finish_apply_start!
    @single_customer.renewal = Renewal.new(user_id: current_user.id) #建立并初始化社保续费状态对象
    @single_customer.save!
    redirect_to single_customers_list_apply_start_path, 
                notice: "个人客户 #{@single_customer.name} 已申报在保."
  end

  def list_apply_stop #可能申报停保的列表
    if params[:single_customer] && params[:single_customer][:name]
      @single_customers = SingleCustomer.by_partial_name(params[:single_customer][:name]).with_serving_state.page params[:page]
      @single_customer = SingleCustomer.new(single_customer_params)
    else
      @single_customers = SingleCustomer.with_serving_state.page params[:page]
    end
  end

  def finish_apply_stop #申报停保的操作
    if MoneyArrivalFile.business_files("SingleCustomer",@single_customer.id, 
        @single_customer.updated_at.to_s, "finish_apply_stop").count <= 0
      redirect_to single_customers_list_apply_stop_path, 
                error: "操作失败, 个人客户 #{@single_customer.name} 的申报操作文件尚未上传."
      return
    end
    @single_customer.finish_apply_stop!
    redirect_to single_customers_list_apply_stop_path, 
                notice: "个人客户 #{@single_customer.name} 已申报停保."
  end

  def list_apply_restart #可能重新申报入保的列表
    if params[:single_customer] && params[:single_customer][:name]
      @single_customers = SingleCustomer.by_partial_name(params[:single_customer][:name]).with_stopped_state.page params[:page]
      @single_customer = SingleCustomer.new(single_customer_params)
    else
      @single_customers = SingleCustomer.with_stopped_state.page params[:page]
    end
  end

  def finish_apply_restart #重新申报入保的操作
    if MoneyArrivalFile.business_files("SingleCustomer",@single_customer.id, 
        @single_customer.updated_at.to_s, "finish_apply_restart").count <= 0
      redirect_to single_customers_list_apply_restart_path, 
                error: "操作失败, 个人客户 #{@single_customer.name} 的申报操作文件尚未上传."
      return
    end    
    @single_customer.finish_apply_restart!
    redirect_to single_customers_list_apply_restart_path, 
                notice: "个人客户 #{@single_customer.name} 已重新申报入保."
  end

  def list_need_renew
    respond_to do |format|
      format.html { @single_customers = SingleCustomer.need_renew.page params[:page] } #网页正常显示
      format.xls do #导出到excel
        @single_customers = SingleCustomer.need_renew
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "社保待续费人员清单" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0          1      2     3       4       5       6       7         8             9                10               11
        sheet1.row(0).concat %w{内部序号 档案编号 姓名 服务状态 身份证号 电话 其他电话 业务员 上次缴费日期 上次社保缴费金额 上次社保服务开始 上次社保服务结束}
        @single_customers.each_with_index do |r,i|
          #last_charge = Charge.of_same_customer(r.id).where("months_shebao>0").order(end_date_shebao: :desc).first
          last_charge = Charge.of_same_customer(r.id).where.not(end_date_shebao: nil).order(end_date_shebao: :desc).first
          sheet1.row(i+1).push r.id, r.document_no, r.name, r.translate_workflow_state_name(SingleCustomer::WORKFLOW_STATE_NAMES).to_s,
                                r.id_no, r.tel, r.other_contact_call, User.find(r.user_id).name, 
                                last_charge.money_arrival_date, last_charge.price_shebao*last_charge.months_shebao,
                                last_charge.start_date_shebao, last_charge.end_date_shebao
          [8,10,11].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "社保待续费人员清单" + Date.today.to_s + ".xls",#filename: CGI::escape("客户信息表" + Date.today.to_s + ".xls"),
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def list_need_append_shebao
    year = Date.today.year
    base = ShebaoBase.where(year: year).first.base
    @single_customers = SingleCustomer.need_append_shebao.page params[:page]
  end

  def list_total
    #@single_customers = SingleCustomer.all.page params[:page]
    respond_to do |format|
      format.html { @single_customers = SingleCustomer.all.page params[:page] } #网页正常显示
      format.xls do #导出到excel
        #@single_customers = SingleCustomer.all
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "客户信息表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0          1      2     3       4     5    6       7       8         9         10       11     12     13      14      15
        sheet1.row(0).concat %w{内部序号 档案编号 姓名 客户状态 公积金 性别 民族 出生日期 身份证号 身份证地址 户口类型 教育程度 电话 通讯地址 业务员 录入日期 }
        SingleCustomer.all.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.document_no, r.name, r.translate_workflow_state_name(SingleCustomer::WORKFLOW_STATE_NAMES).to_s,
                                r.gongjijin.nil? ? nil : r.gongjijin.translate_workflow_state_name(Gongjijin::WORKFLOW_STATE_NAMES).to_s,
                                r.gender==1 ? '男' : '女', r.ethnic_name, r.birth, r.id_no, r.id_address, r.hukou_type_name(r.hukou_type),
                                r.education, r.tel , r.communication_address, User.find(r.user_id).name, r.input_date
          [7,15].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "客户信息表" + Date.today.to_s + ".xls",#filename: CGI::escape("客户信息表" + Date.today.to_s + ".xls"),
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def list_edit
    if params[:single_customer] && params[:single_customer][:name]
      @single_customers = SingleCustomer.by_partial_name(params[:single_customer][:name]).page params[:page]
      @single_customer = SingleCustomer.new(single_customer_params)
    else
      @single_customers = SingleCustomer.all.page params[:page]
    end
  end

  def query
    redirect_to single_customers_url and return unless params[:single_customer]

    @single_customer = SingleCustomer.new(single_customer_params)
    @input_date_from = params[:single_customer][:input_date_from]
    @input_date_to = params[:single_customer][:input_date_to]
    

    s = Arel::Table.new(:single_customers)

    conds = s[:id].gt(0)

    if @single_customer.name.length>0
      conds = conds.and(s[:name].matches("%#{@single_customer.name}%"))
    end
    
    if @single_customer.user_id and @single_customer.user_id>0
      conds = conds.and(s[:user_id].eq(@single_customer.user_id))
    end

    if @single_customer.workflow_state && @single_customer.workflow_state.length > 0
      conds = conds.and(s[:workflow_state].eq(@single_customer.workflow_state))
    end

    if params[:single_customer][:input_date_from].length>0
      conds = conds.and(s[:input_date].gteq(params[:single_customer][:input_date_from])) 
    end

    if params[:single_customer][:input_date_to].length>0
      conds = conds.and(s[:input_date].lteq(params[:single_customer][:input_date_to])) 
    end

    [:is_usage_zhengchang,:is_usage_ruxue,:is_usage_luohu,:is_usage_shenyu,:is_usage_yiliao,:is_usage_gouche,:is_usage_goufang,:is_usage_daikuan].each do |b|
      if @single_customer.send b
        #sqlite与mysql数据库中的多个boolean字段可能以1/0或t/f保存(sqlite中第一个是1/0,后面是t/f),不能直接用true/false
        #conds = conds.and(s[b].in([1,"t"])) 
        #而mysql是以1/0来存储,现在重置为mysql标准
        conds = conds.and(s[b].eq(1)) 
      end
    end

    s = s.where(conds).project(s[:id]).to_sql

    ids = SingleCustomer.connection.select_all(s).rows.flatten

    if params[:single_customer] && params[:single_customer][:gongjijin_workflow_state].length > 0
      @gongjijin_workflow_state = params[:single_customer][:gongjijin_workflow_state]
      ids = ids & Gongjijin.of_workflow_state(params[:single_customer][:gongjijin_workflow_state]).collect(&:single_customer_id)
    end

    @single_customers = SingleCustomer.where('id in (?)',ids)

    #按照周总后来的意见,暂时不作查询出的业务员直属的客户的限制
    #unless current_user.is_leader
    #  @single_customers = @single_customers.where(user_id: current_user.id)
    #end

    @single_customers = @single_customers.page params[:page]

    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_single_customer
      @single_customer = SingleCustomer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def single_customer_params
      unless  params[:single_customer].nil?
      params.require(:single_customer).permit(:name, :gender, :ethnic_name, :birth, :id_no, :id_address, :hukou_type, 
                                              :education, :tel, :other_contact_person, :other_contact_call, :qq, :wechat, 
                                              :email, :communication_address, :is_doc_for_shebao, :is_doc_for_shigong, 
                                              :is_doc_for_shenggong, :is_doc_for_butuichajia, :is_doc_for_xufei, 
                                              :is_doc_for_qita, :is_usage_zhengchang, :is_usage_ruxue, :is_usage_luohu, 
                                              :is_usage_shenyu, :is_usage_yiliao, :is_usage_gouche, :is_usage_goufang, 
                                              :is_usage_daikuan, :creator, :creator_tel, :comment, :user_id, :input_date, 
                                              :document_no, :workflow_state, :comment_for_qita)
      end
    end

    def set_users
      @users = User.all
    end
end
