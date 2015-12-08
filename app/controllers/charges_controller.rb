class ChargesController < ApplicationController
  before_action :set_charge, only: [:show, :edit, :update, :destroy, 
                                    :print_form, :leader_check,
                                    :finish_money_check,:set_money_arrival_date]
  before_action :set_single_customer, only: [:index, :new, :create, :update, :print_form, :show]

  # GET /charges
  # GET /charges.json
  def index
    @charges = Charge.of_same_customer(params[:single_customer_id]).page params[:page]
  end

  # GET /charges/1
  # GET /charges/1.json
  def show
    @attaches = MoneyArrivalFile.business_files_all("Charge",@charge.id).pluck(:id,:file_name,:user_id,:created_at)
    render :show, layout: "simple"
  end

  # GET /charges/new
  def new
    @charge = Charge.new
  end

  # GET /charges/1/edit
  def edit
  end

  # POST /charges
  # POST /charges.json
  def create
    @charge = Charge.new(charge_params)
    @charge.single_customer = @single_customer
    @charge.user_id= @single_customer.user_id #session["current_user_id"]
    if @single_customer.user_id != session["current_user_id"]
      @charge.comment = @charge.comment + "代办人:" + current_user.name
    end
    respond_to do |format|
      if @charge.save
        format.html { redirect_to single_customer_charges_path(@single_customer.id), 
                                  notice: "个人客户 #{@single_customer.name} 的缴费记录已建立." }
        format.json { render :show, status: :created, location: @charge }
      else
        format.html { render :new }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charges/1
  # PATCH/PUT /charges/1.json
  def update
    respond_to do |format|
      if @charge.update(charge_params)
        format.html { redirect_to single_customer_charges_path(@single_customer.id), 
                                  notice: "个人客户 #{@single_customer.name} 的缴费记录已更改." }
        format.json { render :show, status: :ok, location: @charge }
      else
        format.html { render :edit }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge.destroy
    respond_to do |format|
      format.html { redirect_to charges_url, notice: 'Charge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
###########################################################################################################
  def print_form
    render layout: "simple"
  end

  def money_arrival_check
    if params[:charge] && params[:charge][:single_customer_name]
      @single_customer_name = params[:charge][:single_customer_name]
      charge_ids = Charge.with_new_state.find_all{|c| c.single_customer.name.include? @single_customer_name}.collect(&:id)
      @charges = Charge.unscoped.where(id: charge_ids)
    else
      @charges = Charge.unscoped.with_new_state
    end

    #进行资金到账核对的时候,取消缺省排序设置,将创建日期在前面的排在前面,提醒财务及时处理积累历史记录
    @charges = @charges.order(created_at: :asc).page params[:page]
  end

  def commission_input_allowed
    #@charges = Charge.with_money_arrived_state.managed_by_users(current_user.direct_subordinates_with_self.collect(&:id)).page params[:page]
    @charges = Charge.with_money_arrived_state.managed_by_users(current_user.id).page params[:page]
  end

  def list_for_leader_check
    @charges = Charge.with_commission_finished_state.page params[:page]
  end

  def leader_check
    @charge.finish_leader_check!
    redirect_to charges_for_leader_check_path, 
                notice: "个人客户 #{@charge.single_customer.name} 的缴费记录已审核通过."
  end

  def list_total #缴费单查询
    respond_to do |format|
      format.html { @charges = Charge.all.page params[:page]} #网页正常显示
      format.xls do #导出到excel

        @money_arrival_date_from = params[:money_arrival_date_from] if params[:money_arrival_date_from]
        @money_arrival_date_to = params[:money_arrival_date_to] if params[:money_arrival_date_to]
        @money_check_date_from = params[:money_check_date_from] if params[:money_check_date_from]
        @money_check_date_to = params[:money_check_date_to] if params[:money_check_date_to]
        
        if @money_check_date_from && @money_check_date_to
          @charges = Charge.where("money_check_date >= :money_check_date_from and money_check_date <=:money_check_date_to",
            money_check_date_from: @money_check_date_from, money_check_date_to: Date.parse(@money_check_date_to))
        else
          @charges = Charge.all
        end

        if @money_arrival_date_from && @money_arrival_date_to
          @charges = @charges.where("money_arrival_date >= :money_arrival_date_from and money_arrival_date <=:money_arrival_date_to",
            money_arrival_date_from: @money_arrival_date_from, money_arrival_date_to: Date.parse(@money_arrival_date_to))
        end

        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "缴费记录表" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0          1        2         3       4         5         6        7        8         9         10           
        sheet1.row(0).concat %w{内部序号 客户姓名 收款类型  社保月费 社保月数 社保起始 社保结束 公积金月费 公积金月数 公积金起始 公积金结束 
          服务月费 服务月数 服务起始 服务结束 材料月费 材料月数 材料起始 材料结束 补交月费 补交月数 补交起始 补交结束 差价月费 差价月数 差价起始 差价结束 个税月费 个税月数 个税起始 个税结束 总计 资金到账日期 资金审核日期 状态 业务员}
        # => 11      12        13       14       15        16      17        18      19        20      21       22     23        24         25      26        27      28        29      30      31      32          33        34    35
        @charges.each_with_index do |r,i| 
          sheet1.row(i+1).push r.id, r.single_customer.name, r.charge_type, 
                              r.price_shebao, r.months_shebao, r.start_date_shebao, r.end_date_shebao,
                              r.price_gongjijin, r.months_gongjijin, r.start_date_gongjijin, r.end_date_gongjijin,
                              r.price_fuwufei, r.months_fuwufei, r.start_date_fuwufei, r.end_date_fuwufei,
                              r.price_cailiaofei, r.months_cailiaofei, r.start_date_cailiaofei, r.end_date_cailiaofei,
                              r.price_bujiao, r.months_bujiao, r.start_date_bujiao, r.end_date_bujiao,
                              r.price_chajia, r.months_chajia, r.start_date_chajia, r.end_date_chajia,
                              r.price_geshui, r.months_geshui, r.start_date_geshui, r.end_date_geshui,
                              r.money_total, r.money_arrival_date, r.money_check_date, 
                              r.translate_workflow_state_name(Charge::WORKFLOW_STATE_NAMES).to_s, r.user.name
          [5,6,9,10,13,14,17,18,21,22,25,26,29,30,32,33].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "缴费记录表" + Date.today.to_s + ".xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  #query函数此处实现主要用了where chaining, 根据
  #http://stackoverflow.com/questions/11702341/lazy-loading-in-rails-3-2-6, 将只会在最后产生一次查询,无性能影响.
  def query 
    redirect_to charges_list_total_url and return unless params[:charge]

    @charge = Charge.new(charge_params)
    @single_customer_name = params[:charge][:single_customer_name]
    @money_arrival_date_from = params[:charge][:money_arrival_date_from]
    @money_arrival_date_to = params[:charge][:money_arrival_date_to]
    @money_check_date_from = params[:charge][:money_check_date_from]
    @money_check_date_to = params[:charge][:money_check_date_to]
    
    if @single_customer_name.length > 0
      results ||= Charge.all
      results = results.of_customer_name_like(@single_customer_name)
    end

    if @charge.user_id and @charge.user_id >0
      results ||= Charge.all
      results = results.managed_by_users([@charge.user_id])
    end

    if @charge.workflow_state && @charge.workflow_state.length > 0
      results ||= Charge.all
      results = results.of_workflow_state(@charge.workflow_state)
    end

    if @money_arrival_date_from.length>0
      results ||= Charge.all
      results = results.of_money_arrival_date_from(@money_arrival_date_from)
    end

    if @money_arrival_date_to.length>0
      results ||= Charge.all
      results = results.of_money_arrival_date_to(@money_arrival_date_to)
    end

    if @money_check_date_from.length>0
      results ||= Charge.all
      results = results.of_money_check_date_from(@money_check_date_from)
    end

    if @money_check_date_to.length>0
      results ||= Charge.all
      results = results.of_money_check_date_to(@money_check_date_to)
    end

    if @charge.charge_type && @charge.charge_type.length > 0
      results ||= Charge.all
      results = results.of_charge_type(@charge.charge_type)
    end

    results ||= Charge.all
    @charges = results.page params[:page]

    render :list_total
  end

  def set_money_arrival_date
    if params[:charge] && params[:charge][:money_arrival_date] #posted
      if @charge.update(money_arrival_date: params[:charge][:money_arrival_date])
        redirect_to  charges_for_money_arrival_check_path, 
                notice: "个人客户 #{@charge.single_customer.name} 的缴费到账时间已设置."
        return
      end
    else #get
      #
    end
  end

  def finish_money_check
    if MoneyArrivalFile.where(business_type: "Charge", main_object_id: @charge.id).pluck(:id).count <= 0
          redirect_to  charges_for_money_arrival_check_path, 
                error: "个人客户 #{@charge.single_customer.name} 的缴费记录附件尚未上传."
          return
    end
    unless @charge.money_arrival_date
      redirect_to  charges_for_money_arrival_check_path, 
                error: "个人客户 #{@charge.single_customer.name} 的缴费到账时间尚未设置."
          return
    end

    @charge.finish_money_check! #同时完成缴费单的资金检查
    @charge.update(money_check_date: Date.current) #设置资金审核日期
    redirect_to  charges_for_money_arrival_check_path, 
                notice: "个人客户 #{@charge.single_customer.name} 的缴费资金已确认到账."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_charge
      # routes.rb中get :print_form => 'charges#print_form'传入的是:charge_id而不是:id
      @charge = params[:id].nil? ? Charge.find(params[:charge_id]) : Charge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def charge_params
      params.require(:charge).permit(:single_customer_id, :user_id, :charge_type, 
                                      :money_arrival_state, :money_arrival_time, :is_lead_checked, 
                                      :lead_check_time, :shenbao_state, :shenbao_time, :start_date, 
                                      :end_date, :price_shebao, :months_shebao, :price_gongjijin, 
                                      :months_gongjijin, :price_fuwufei, :months_fuwufei, 
                                      :price_cailiaofei, :months_cailiaofei, :price_bujiao, 
                                      :months_bujiao, :comment, :workflow_state,
                                      :start_date_shebao, :end_date_shebao,
                                      :start_date_gongjijin, :end_date_gongjijin,
                                      :start_date_fuwufei, :end_date_fuwufei,
                                      :start_date_cailiaofei, :end_date_cailiaofei,
                                      :start_date_bujiao, :end_date_bujiao,
                                      :price_geshui, :months_geshui, :start_date_geshui, :end_date_geshui,
                                      :price_chajia, :months_chajia, :start_date_chajia, :end_date_chajia)
    end

    def set_single_customer
      @single_customer = SingleCustomer.find(params[:single_customer_id])
    end
end
