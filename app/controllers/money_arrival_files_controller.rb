class MoneyArrivalFilesController < ApplicationController
  before_action :set_money_arrival_file, only: [:show, :edit, :update, :destroy, :send_raw, :send_display]
  before_action :set_business_data, only: [:new, :create]

  # GET /money_arrival_files
  # GET /money_arrival_files.json
  def index
    @money_arrival_files = MoneyArrivalFile.all
  end

  # GET /money_arrival_files/1
  # GET /money_arrival_files/1.json
  def show
  end

  # GET /money_arrival_files/new
  def new
    @money_arrival_file = MoneyArrivalFile.new
    #@charges = Charge.where(id: @charge.id).page params[:page]
  end

  # GET /money_arrival_files/1/edit
  def edit
  end

  # POST /money_arrival_files
  # POST /money_arrival_files.json
  def create
    @money_arrival_file = MoneyArrivalFile.new(money_arrival_file_params)

    @money_arrival_file.business_type = params[:business_type]
    @money_arrival_file.main_object_id = params[:main_object_id]
    @money_arrival_file.extra_data = params[:extra_data]
    @money_arrival_file.business_action = params[:business_action]

    @money_arrival_file.user_id=session["current_user_id"]

    respond_to do |format|
      if @money_arrival_file.save
        format.html { render :success, layout: "blank" }
        format.json { render :show, status: :created, location: @money_arrival_file }
      else
        format.html { render :new }
        format.json { render json: @money_arrival_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /money_arrival_files/1
  # PATCH/PUT /money_arrival_files/1.json
  def update
    respond_to do |format|
      if @money_arrival_file.update(money_arrival_file_params)
        format.html { redirect_to @money_arrival_file, notice: 'Money arrival file was successfully updated.' }
        format.json { render :show, status: :ok, location: @money_arrival_file }
      else
        format.html { render :edit }
        format.json { render json: @money_arrival_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /money_arrival_files/1
  # DELETE /money_arrival_files/1.json
  def destroy
    @money_arrival_file.destroy
    respond_to do |format|
      format.html { redirect_to money_arrival_files_url, notice: 'Money arrival file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_raw
    send_data(@money_arrival_file.file_raw,
              filename: @money_arrival_file.file_name,
              type: @money_arrival_file.content_type,
              disposition: "attachment")
  end

  def send_display
    send_data(@money_arrival_file.file_raw,
              filename: @money_arrival_file.file_name,
              type: @money_arrival_file.content_type,
              disposition: "inline")
  end

  def new_ng
    @money_arrival_file = MoneyArrivalFile.new
    render layout: 'blank'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_money_arrival_file
      @money_arrival_file = MoneyArrivalFile.find(params[:id])
    end

    def set_business_data
      @business_type = params[:business_type]
      @main_object_id = params[:main_object_id]
      @extra_data = params[:extra_data]
      @business_action = params[:business_action]
      #@main_object = params[:business_type].to_s.to_class.find(params[:main_object_id])
      #@charge = Charge.find(params[:charge_id]) if params[:charge_id].length > 0
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def money_arrival_file_params
      params.require(:money_arrival_file).permit(:uploaded_file)
    end
end
