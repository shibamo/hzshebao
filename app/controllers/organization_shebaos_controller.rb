class OrganizationShebaosController < ApplicationController
  before_action :set_model_class
  before_action :set_organization_shebao, 
                  only: [:show, :edit, :update, :finish_apply_start, 
                        :finish_apply_stop, :finish_apply_restart]

  # GET /organization_shebaos
  # GET /organization_shebaos.json
  def index
    @organization_shebaos = @model_class.all
  end

  # GET /organization_shebaos/1
  # GET /organization_shebaos/1.json
  def show
  end

  # GET /organization_shebaos/new
  def new
    @organization_shebao = @model_class.new
  end

  # GET /organization_shebaos/1/edit
  def edit
  end

  # POST /organization_shebaos
  # POST /organization_shebaos.json
  def create
    @organization_shebao = @model_class.new(organization_shebao_params)

    respond_to do |format|
      if @organization_shebao.save
        format.html { redirect_to @organization_shebao, notice: 'Organization shebao was successfully created.' }
        format.json { render :show, status: :created, location: @organization_shebao }
      else
        format.html { render :new }
        format.json { render json: @organization_shebao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_shebaos/1
  # PATCH/PUT /organization_shebaos/1.json
  def update
    respond_to do |format|
      if @organization_shebao.update(organization_shebao_params)
        format.html { redirect_to @organization_shebao, notice: 'Organization shebao was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_shebao }
      else
        format.html { render :edit }
        format.json { render json: @organization_shebao.errors, status: :unprocessable_entity }
      end
    end
  end

  ##################################################################################################
  def list_apply_start #需要开通的机构员工客户列表
    respond_to do |format|
      format.html { @organization_shebaos = @model_class.can_start.page params[:page] } #网页正常显示
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
        @model_class.can_start.each do |o|
          r = o.organization_customer
          sheet1.row(i).push r.id_no, r.name, r.gender, (r.valid_start.year*100 + r.valid_start.month), 
                              0.00, 91101, "01", r.hukou_type, r.communication_address, 310000, r.tel, r.email
          i = i+1
        end

        book.write file_contents
        file_contents.rewind
        send_data file_contents.read,
              filename: "社保批量申报.xls",
              type: :xls,
              disposition: "attachment"
      end
    end
  end

  def finish_apply_start#完成开通服务
    if MoneyArrivalFile.business_files("OrganizationShebao",@organization_shebao.id, 
        @organization_shebao.updated_at.to_s, "finish_apply_start").count <= 0
      redirect_to organization_shebaos_list_apply_start_path, 
                error: "操作失败, 机构员工客户 #{@organization_shebao.organization_customer.name} 的开通社保操作文件尚未上传."
      return
    end
    @organization_shebao.finish_apply_start!
    @organization_shebao.save!
    redirect_to organization_shebaos_list_apply_start_path, 
                notice: "机构员工客户 #{@organization_shebao.organization_customer.name} 已登记开通社保."
  end

  def list_apply_stop #列出可能需要停止服务的机构员工客户列表
    if params[:organization_customer] && params[:organization_customer][:name]
      @organization_shebaos = @model_class.can_stop.where(organization_customer_id: OrganizationCustomer.by_partial_name(params[:organization_customer][:name]).pluck(:id)).page params[:page]
      @organization_customer = OrganizationCustomer.new(organization_customer_params)
    else
      @organization_shebaos = @model_class.can_stop.page params[:page]
    end
  end

  def finish_apply_stop#完成停止服务
    if MoneyArrivalFile.business_files("OrganizationShebao",@organization_shebao.id, 
        @organization_shebao.updated_at.to_s, "finish_apply_stop").count <= 0
      redirect_to organization_shebaos_list_apply_stop_path, 
                error: "操作失败, 机构员工客户 #{@organization_shebao.organization_customer.name} 的停交社保操作文件尚未上传."
      return
    end
    @organization_shebao.finish_apply_stop!
    redirect_to organization_shebaos_list_apply_stop_path, 
                notice: "机构员工客户 #{@organization_shebao.organization_customer.name} 已登记停交社保."
  end

  def list_apply_restart #列出可能需要重新开启服务的机构员工客户列表
    if params[:organization_customer] && params[:organization_customer][:name]
      @organization_shebaos = @model_class.can_restart.where(organization_customer_id: OrganizationCustomer.by_partial_name(params[:organization_customer][:name]).pluck(:id)).page params[:page]
      @organization_customer = OrganizationCustomer.new(organization_customer_params)
    else
      @organization_shebaos = @model_class.can_restart.page params[:page]
    end
  end

  def finish_apply_restart#完成重启服务
    if MoneyArrivalFile.business_files("OrganizationShebao",@organization_shebao.id, 
        @organization_shebao.updated_at.to_s, "finish_apply_restart").count <= 0
      redirect_to organization_shebaos_list_apply_restart_path, 
                error: "操作失败, 机构员工客户 #{@organization_shebao.organization_customer.name} 的重新开通社保文件尚未上传."
      return
    end    
    @organization_shebao.finish_apply_restart!
    redirect_to organization_shebaos_list_apply_restart_path, 
                notice: "机构员工客户 #{@organization_shebao.organization_customer.name} 已重新开通社保."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_shebao
      @organization_shebao = @model_class.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_shebao_params
      params.require(:organization_shebao).permit(:organization_customer_id, :account_no, :workflow_state)
    end

    def set_model_class
      @model_class = OrganizationShebao
    end
end
