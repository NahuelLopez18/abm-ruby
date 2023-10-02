class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = search_products.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Producto creado exitosamente.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Producto actualizado exitosamente.' }
        format.json { render json: @product, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deleted_product = @product.dup
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Producto eliminado exitosamente.' }
      format.json { render json: @deleted_product, status: :ok }
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Producto no encontrado'
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end

  def search_products
    if params[:q]
      Product.where("name LIKE ?", "%#{params[:q]}%")
    else
      Product.all
    end
  end
end
