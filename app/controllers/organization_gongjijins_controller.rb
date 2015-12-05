class OrganizationGongjijinsController < ApplicationController
  before_action :set_model_class
  before_action :set_organization_gongjijin, 
                only: [:show, :edit, :update, :finish_apply_start, 
                        :finish_apply_stop, :finish_apply_restart]

  # GET /organization_gongjijins
  # GET /organization_gongjijins.json
  def index
    @organization_gongjijins = OrganizationGongjijin.all
  end

  # GET /organization_gongjijins/1
  # GET /organization_gongjijins/1.json
  def show
  end

  # GET /organization_gongjijins/new
  def new
    @organization_gongjijin = OrganizationGongjijin.new
  end

  # GET /organization_gongjijins/1/edit
  def edit
  end

  # POST /organization_gongjijins
  # POST /organization_gongjijins.json
  def create
    @organization_gongjijin = OrganizationGongjijin.new(organization_gongjijin_params)

    respond_to do |format|
      if @organization_gongjijin.save
        format.html { redirect_to @organization_gongjijin, notice: 'Organization gongjijin was successfully created.' }
        format.json { render :show, status: :created, location: @organization_gongjijin }
      else
        format.html { render :new }
        format.json { render json: @organization_gongjijin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_gongjijins/1
  # PATCH/PUT /organization_gongjijins/1.json
  def update
    respond_to do |format|
      if @organization_gongjijin.update(organization_gongjijin_params)
        format.html { redirect_to @organization_gongjijin, notice: 'Organization gongjijin was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_gongjijin }
      else
        format.html { render :edit }
        format.json { render json: @organization_gongjijin.errors, status: :unprocessable_entity }
      end
    end
  end

  ##################################################################################################
  def list_apply_start #需要开通的机构员工客户列表
    respond_to do |format|
      format.html { @organization_gongjijins = @model_class.can_start.page params[:page] } #网页正常显示
      format.xls do #导出到excel
        Spreadsheet.client_encoding = 'UTF-8'
        file_contents = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet name: "Sheet1"
        sheet1.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold,size: 12
        # =>                      0       1         2         3         4        5
        sheet1.row(0).concat %w{姓名  身份证号  月均工资  缴存比例  月缴存额  工作时间}
        i=1
        @model_class.can_start.each do |o|
          r = o.organization_customer
          sheet1.row(i).push r.name, r.id_no, nil, nil, nil, nil
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

  def finish_apply_start#完成开通服务
    if MoneyArrivalFile.business_files("OrganizationGongjijin",@organization_gongjijin.id, 
        @organization_gongjijin.updated_at.to_s, "finish_apply_start").count <= 0
      redirect_to organization_gongjijins_list_apply_start_path, 
                error: "操作失败, 机构员工客户 #{@organization_gongjijin.organization_customer.name} 的开通公积金操作文件尚未上传."
      return
    end
    @organization_gongjijin.finish_apply_start!
    @organization_gongjijin.save!
    redirect_to organization_gongjijins_list_apply_start_path, 
                notice: "机构员工客户 #{@organization_gongjijin.organization_customer.name} 已登记开通公积金."
  end

  def list_apply_stop #列出可能需要停止服务的机构员工客户列表
    if params[:organization_customer] && params[:organization_customer][:name]
      @organization_gongjijins = @model_class.can_stop.where(organization_customer_id: OrganizationCustomer.by_partial_name(params[:organization_customer][:name]).pluck(:id)).page params[:page]
      @organization_customer = OrganizationCustomer.new(organization_customer_params)
    else
      @organization_gongjijins = @model_class.can_stop.page params[:page]
    end
  end

  def finish_apply_stop#完成停止服务
    if MoneyArrivalFile.business_files("OrganizationGongjijin",@organization_gongjijin.id, 
        @organization_gongjijin.updated_at.to_s, "finish_apply_stop").count <= 0
      redirect_to organization_gongjijins_list_apply_stop_path, 
                error: "操作失败, 机构员工客户 #{@organization_gongjijin.organization_customer.name} 的停交公积金操作文件尚未上传."
      return
    end
    @organization_gongjijin.finish_apply_stop!
    redirect_to organization_gongjijins_list_apply_stop_path, 
                notice: "机构员工客户 #{@organization_gongjijin.organization_customer.name} 已登记停交公积金."
  end

  def list_apply_restart #列出可能需要重新开启服务的机构员工客户列表
    if params[:organization_customer] && params[:organization_customer][:name]
      @organization_gongjijins = @model_class.can_restart.where(organization_customer_id: OrganizationCustomer.by_partial_name(params[:organization_customer][:name]).pluck(:id)).page params[:page]
      @organization_customer = OrganizationCustomer.new(organization_customer_params)
    else
      @organization_gongjijins = @model_class.can_restart.page params[:page]
    end
  end

  def finish_apply_restart#完成重启服务
    if MoneyArrivalFile.business_files("OrganizationGongjijin",@organization_gongjijin.id, 
        @organization_gongjijin.updated_at.to_s, "finish_apply_restart").count <= 0
      redirect_to organization_gongjijins_list_apply_restart_path, 
                error: "操作失败, 机构员工客户 #{@organization_gongjijin.organization_customer.name} 的重新开通公积金文件尚未上传."
      return
    end    
    @organization_gongjijin.finish_apply_restart!
    redirect_to organization_gongjijins_list_apply_restart_path, 
                notice: "机构员工客户 #{@organization_gongjijin.organization_customer.name} 已重新开通公积金."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_gongjijin
      @organization_gongjijin = OrganizationGongjijin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_gongjijin_params
      params.require(:organization_gongjijin).permit(:organization_customer_id, :account_no, :workflow_state)
    end

    def set_model_class
      @model_class = OrganizationGongjijin
    end
end
