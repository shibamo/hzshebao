class GongjijinsController < ApplicationController
  before_action :set_gongjijin, only: [:show, :edit, :update, :destroy, 
    :finish_apply_start, :finish_apply_stop, :finish_apply_restart]

  # GET /gongjijins
  # GET /gongjijins.json
  def index
    @gongjijins = Gongjijin.all
  end

  # GET /gongjijins/1
  # GET /gongjijins/1.json
  def show
  end

  # GET /gongjijins/new
  def new
    @gongjijin = Gongjijin.new
  end

  # GET /gongjijins/1/edit
  def edit
  end

  # POST /gongjijins
  # POST /gongjijins.json
  def create
    @gongjijin = Gongjijin.new(gongjijin_params)

    respond_to do |format|
      if @gongjijin.save
        format.html { redirect_to @gongjijin, notice: 'Gongjijin was successfully created.' }
        format.json { render :show, status: :created, location: @gongjijin }
      else
        format.html { render :new }
        format.json { render json: @gongjijin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gongjijins/1
  # PATCH/PUT /gongjijins/1.json
  def update
    respond_to do |format|
      if @gongjijin.update(gongjijin_params)
        format.html { redirect_to @gongjijin, notice: 'Gongjijin was successfully updated.' }
        format.json { render :show, status: :ok, location: @gongjijin }
      else
        format.html { render :edit }
        format.json { render json: @gongjijin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gongjijins/1
  # DELETE /gongjijins/1.json
  def destroy
    @gongjijin.destroy
    respond_to do |format|
      format.html { redirect_to gongjijins_url, notice: 'Gongjijin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  ##################################################################################################
  def list_apply_start
    respond_to do |format|
      format.html { @gongjijins = Gongjijin.need_start_gongjijin.page params[:page] } #网页正常显示
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "Sheet1"
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0       1         2         3         4        5
        sheet1.row(0).concat %w{姓名  身份证号  月均工资  缴存比例  月缴存额  工作时间}
        i=1
        Gongjijin.need_start_gongjijin.each do |g|
          r = g.single_customer
          sheet1.row(i).push r.name, r.id_no, nil, nil, nil, 
            (r.gongjijin_start_date.year*100 + r.gongjijin_start_date.month)
          i = i+1
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "公积金批量申报.xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def finish_apply_start
    if MoneyArrivalFile.business_files("Gongjijin",@gongjijin.id, 
        @gongjijin.updated_at.to_s, "finish_apply_start").count <= 0
      redirect_to gongjijins_list_apply_start_path, 
                error: "操作失败, 个人客户 #{@gongjijin.single_customer.name} 的开通公积金操作文件尚未上传."
      return
    end
    @gongjijin.finish_apply_start!
    @gongjijin.save!
    redirect_to gongjijins_list_apply_start_path, 
                notice: "个人客户 #{@gongjijin.single_customer.name} 已登记开通公积金."
  end

  def list_apply_stop
    if params[:single_customer] && params[:single_customer][:name]
      @gongjijins = Gongjijin.with_serving_state.where(single_customer_id: SingleCustomer.by_partial_name(params[:single_customer][:name]).pluck(:id)).page params[:page]
      @single_customer = SingleCustomer.new(single_customer_params)
    else
      @gongjijins = Gongjijin.with_serving_state.page params[:page]
    end
  end

  def finish_apply_stop
    if MoneyArrivalFile.business_files("Gongjijin",@gongjijin.id, 
        @gongjijin.updated_at.to_s, "finish_apply_stop").count <= 0
      redirect_to gongjijins_list_apply_stop_path, 
                error: "操作失败, 个人客户 #{@gongjijin.single_customer.name} 的停交公积金操作文件尚未上传."
      return
    end
    @gongjijin.finish_apply_stop!
    redirect_to gongjijins_list_apply_stop_path, 
                notice: "个人客户 #{@gongjijin.single_customer.name} 已登记停交公积金."
  end

  def list_apply_restart
    if params[:single_customer] && params[:single_customer][:name]
      @gongjijins = Gongjijin.with_stopped_state.where(single_customer_id: SingleCustomer.by_partial_name(params[:single_customer][:name]).pluck(:id)).page params[:page]
      @single_customer = SingleCustomer.new(single_customer_params)
    else
      @gongjijins = Gongjijin.with_stopped_state.page params[:page]
    end
  end

  def finish_apply_restart
    if MoneyArrivalFile.business_files("Gongjijin",@gongjijin.id, 
        @gongjijin.updated_at.to_s, "finish_apply_restart").count <= 0
      redirect_to gongjijins_list_apply_restart_path, 
                error: "操作失败, 个人客户 #{@gongjijin.single_customer.name} 的重新开通公积金文件尚未上传."
      return
    end    
    @gongjijin.finish_apply_restart!
    redirect_to gongjijins_list_apply_restart_path, 
                notice: "个人客户 #{@gongjijin.single_customer.name} 已重新开通公积金."
  end

  def list_need_renew
    respond_to do |format|
      format.html { @gongjijins = Gongjijin.need_renew.page params[:page] } #网页正常显示
      format.xls do #导出到excel
        @gongjijins = Gongjijin.need_renew
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "公积金待续费人员清单" + Date.today.to_s
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0          1      2     3       4       5       6       7         8             9                    10                 11
        sheet1.row(0).concat %w{内部序号 档案编号 姓名 服务状态 身份证号 电话 其他电话 业务员 上次缴费日期 上次公积金缴费金额 上次公积金服务开始 上次公积金服务结束}
        @gongjijins.each_with_index do |r,i|
          s = r.single_customer
          #last_charge = Charge.of_same_customer(s.id).first
          #last_charge = Charge.of_same_customer(s.id).where("months_gongjijin>0").order(end_date_gongjijin: :desc).first
          last_charge = Charge.of_same_customer(s.id).where.not(end_date_gongjijin: nil).order(end_date_gongjijin: :desc).first
          sheet1.row(i+1).push s.id, s.document_no, s.name, r.translate_workflow_state_name(Gongjijin::WORKFLOW_STATE_NAMES).to_s,
                                s.id_no, s.tel, s.other_contact_call, User.find(s.user_id).name, 
                                last_charge.money_arrival_date, last_charge.price_gongjijin*last_charge.months_gongjijin,
                                last_charge.start_date_gongjijin, last_charge.end_date_gongjijin
          [8,10,11].each {|col| sheet1.row(i+1).set_format col, Spreadsheet::Format.new(:number_format => 'YYYY-MM-DD')}                                
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
          filename: "公积金待续费人员清单" + Date.today.to_s + ".xls",#filename: CGI::escape("公积金待续费人员清单" + Date.today.to_s + ".xls"),
          type: :xls,
          disposition: "attachment"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gongjijin
      @gongjijin = Gongjijin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gongjijin_params
      params.require(:gongjijin).permit(:single_customer_id, :account_no, :workflow_state)
    end

    def single_customer_params
      unless  params[:single_customer].nil?
      params.require(:single_customer).permit(:name)
      end
    end
end
