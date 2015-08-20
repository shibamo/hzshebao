class ShebaoBasesController < ApplicationController
  before_action :set_shebao_base, only: [:show, :edit, :update, :destroy]

  # GET /shebao_bases
  # GET /shebao_bases.json
  def index
    @shebao_bases = ShebaoBase.all
  end

  # GET /shebao_bases/1
  # GET /shebao_bases/1.json
  def show
  end

  # GET /shebao_bases/new
  def new
    @shebao_base = ShebaoBase.new
  end

  # GET /shebao_bases/1/edit
  def edit
  end

  # POST /shebao_bases
  # POST /shebao_bases.json
  def create
    @shebao_base = ShebaoBase.new(shebao_base_params)
    @shebao_base.user = current_user
    respond_to do |format|
      if @shebao_base.save
        format.html { redirect_to shebao_bases_path, notice: '社保应缴金额已成功创建.' }
        format.json { render :show, status: :created, location: @shebao_base }
      else
        format.html { render :new }
        format.json { render json: @shebao_base.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shebao_bases/1
  # PATCH/PUT /shebao_bases/1.json
  def update
    @shebao_base.user = current_user
    respond_to do |format|
      if @shebao_base.update(shebao_base_params)
        format.html { redirect_to shebao_bases_path, notice: '社保应缴金额已成功更新.' }
        format.json { render :show, status: :ok, location: @shebao_base }
      else
        format.html { render :edit }
        format.json { render json: @shebao_base.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shebao_bases/1
  # DELETE /shebao_bases/1.json
  def destroy
    @shebao_base.destroy
    respond_to do |format|
      format.html { redirect_to shebao_bases_url, notice: 'Shebao base was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shebao_base
      @shebao_base = ShebaoBase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shebao_base_params
      params.require(:shebao_base).permit(:base, :year, :user_id)
    end
end
