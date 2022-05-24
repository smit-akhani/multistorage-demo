class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @product = Product.new
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    if !check_image_type
      redirect_to products_path, notice: "Image type must be png or jpg."
    elsif !check_doc_type
      redirect_to products_path, notice: "Doc type must be pdf."
    else
      @product = Product.new(product_params)
      respond_to do |format|
        if @product.save
          format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if !check_image_type
      redirect_to products_path, notice: "Image type must be png or jpg."
    elsif !check_doc_type
      redirect_to products_path, notice: "Doc type must be pdf."
    else
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :doc, images: [])
    end

    def check_image_type
      params[:product][:images].shift
      params[:product][:images].each_index do |ele|
        return false unless !params[:product][:images][ele].nil? && ((params[:product][:images][ele]).content_type == "image/jpeg" || (params[:product][:images][ele]).content_type == "image/png") 
      end
      return true
    end

    def check_doc_type
      if !params[:product][:doc].nil? && !params[:product][:doc].content_type == "application/pdf"
        return false
      else
        return true
      end
    end
end
