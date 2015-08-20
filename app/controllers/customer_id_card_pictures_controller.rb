class CustomerIdCardPicturesController < ApplicationController
  before_action :set_customer_id_card_picture, only: [:show, :edit, :update, :destroy, :send_raw]

  # GET /customer_id_card_pictures
  # GET /customer_id_card_pictures.json
  def index
    @customer_id_card_pictures = CustomerIdCardPicture.all
  end

  # GET /customer_id_card_pictures/1
  # GET /customer_id_card_pictures/1.json
  def show
  end

  # GET /customer_id_card_pictures/new
  def new
    @customer_id_card_picture = CustomerIdCardPicture.new
    @single_customer = SingleCustomer.find(params[:single_customer_id])
  end

  # GET /customer_id_card_pictures/1/edit
  def edit
  end

  # POST /customer_id_card_pictures
  # POST /customer_id_card_pictures.json
  def create
    @customer_id_card_picture = CustomerIdCardPicture.new(customer_id_card_picture_params)
    @customer_id_card_picture.customer_type="个人客户"
    @customer_id_card_picture.customer_id=params[:single_customer_id]
    @customer_id_card_picture.user_id=session["current_user_id"]

    respond_to do |format|
      if @customer_id_card_picture.save
        format.html { redirect_to single_customers_path, 
          notice: "个人客户'#{SingleCustomer.find(params[:single_customer_id]).name}'的身份证照片已上传." }
        format.json { render :show, status: :created, location: @customer_id_card_picture }
      else
        format.html { render :new }
        format.json { render json: @customer_id_card_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_id_card_pictures/1
  # PATCH/PUT /customer_id_card_pictures/1.json
  def update
    respond_to do |format|
      if @customer_id_card_picture.update(customer_id_card_picture_params)
        format.html { redirect_to @customer_id_card_picture, notice: 'Customer id card picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer_id_card_picture }
      else
        format.html { render :edit }
        format.json { render json: @customer_id_card_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_id_card_pictures/1
  # DELETE /customer_id_card_pictures/1.json
  def destroy
    @customer_id_card_picture.destroy
    respond_to do |format|
      format.html { redirect_to customer_id_card_pictures_url, notice: 'Customer id card picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_raw
    @customer_id_card_picture = CustomerIdCardPicture.find(params[:id])
    send_data(@customer_id_card_picture.file_raw,
              filename: CGI::escape(@customer_id_card_picture.file_name),
              type: @customer_id_card_picture.content_type,
              disposition: "attachment")
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_id_card_picture
      @customer_id_card_picture = CustomerIdCardPicture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_id_card_picture_params
      params.require(:customer_id_card_picture).permit(:uploaded_file)
    end
end
