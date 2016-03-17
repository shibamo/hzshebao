class OrganizationChargesController < ApplicationController
  before_action :set_organization_charge, only: [:show, :edit, :update, :destroy]
  before_action :set_model_class

  # GET /organization_charges
  # GET /organization_charges.json
  def index
    @organization_charges = OrganizationCharge.all.page params[:page]
  end

  # GET /organization_charges/1
  # GET /organization_charges/1.json
  def show
  end

  # GET /organization_charges/new
  def new
    @organization_charge = OrganizationCharge.new
  end

  # GET /organization_charges/1/edit
  def edit
  end

  # POST /organization_charges
  # POST /organization_charges.json
  def create
    @organization_charge = OrganizationCharge.new(organization_charge_params)

    respond_to do |format|
      if @organization_charge.save
        format.html { redirect_to @organization_charge, notice: 'Organization charge was successfully created.' }
        format.json { render :show, status: :created, location: @organization_charge }
      else
        format.html { render :new }
        format.json { render json: @organization_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_charges/1
  # PATCH/PUT /organization_charges/1.json
  def update
    respond_to do |format|
      if @organization_charge.update(organization_charge_params)
        format.html { redirect_to @organization_charge, notice: 'Organization charge was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization_charge }
      else
        format.html { render :edit }
        format.json { render json: @organization_charge.errors, status: :unprocessable_entity }
      end
    end
  end
############################################################################################
  def list_by_customer #指定机构员工缴费历史记录列表
    if params[:organization_customer_id]
      @organization_charges = @model_class.by_customer(params[:organization_customer_id]).page params[:page]
      @organization_customer = OrganizationCustomer.find(params[:organization_customer_id])
      respond_to do |format|
        format.html {} #网页正常显示,使用缺省view template 
        format.xls do #导出到excel
          Spreadsheet.client_encoding = 'UTF-8'
          file_contents = StringIO.new
          book = Spreadsheet::Workbook.new
          sheet1 = book.create_worksheet name: '机构员工(' + @organization_customer.name + ')缴费历史记录'
          sheet1.row(0).default_format = Spreadsheet::Format.new weight: :bold,size: 12
          sheet1.row(0).push '单位名称：' + @organization_customer.organization.name
          # =>                      0          1        2         3      4       5       6        7         8       9       10       11     12   13
          sheet1.row(1).concat %w{姓名 费用所属日期 缴费基数 企业社保 个人社保 残保 社保管理费 缴费基数 企业公积 个人公积 公积管理费 个税 其它1 其它2 
              其它3 补缴 预缴 应发工资 合计 }
          # => 14    15    16   17      18     
          current_line_number = 4
          @organization_charges.each_with_index do |r,i|
            (2..18).each {|col| sheet1.row(i+2).set_format col, default_excel_money_format}
            sheet1.row(i+2).push r.organization_customer.name, 
              r.start_date.to_s.tr('-','') + "-" + r.end_date.to_s.tr('-',''),
              r.price_shebao_base, r.price_shebao_qiye, r.price_shebao_geren, r.price_canbao, r.price_shebao_guanli,
              r.price_gongjijin_base, r.price_gongjijin_qiye, r.price_gongjijin_geren, r.price_gongjijin_guanli, r.price_geshui,
              r.price_qita_1, r.price_qita_2, r.price_qita_3, r.price_bujiao,
              r.price_yujiao, r.price_gongzi,r.price_receivable_total
          end

          book.write file_contents
          file_contents.rewind
          send_data file_contents.read,
                filename: '机构(' + @organization_customer.organization.name + ')员工(' + @organization_customer.name + ')缴费历史记录' + ".xls",
                type: :xls,
                disposition: "attachment"
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_charge
      @organization_charge = OrganizationCharge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_charge_params
      params.require(:organization_charge).permit(:organization_charge_total_id, :organization_customer_id, :organization_id, :user_id, :price_shebao_base, :price_shebao_qiye, :price_shebao_geren, :price_canbao, :price_shebao_guanli, :price_gongjijin_base, :price_gongjijin_qiye, :price_gongjijin_geren, :price_gongjijin_guanli, :price_geshui, :price_qita_1, :price_qita_2, :price_qita_3, :price_bujiao, :price_yujiao, :price_gongzi, :start_date, :end_date, :comment)
    end

    def set_model_class
      @model_class = OrganizationCharge
    end
end
