class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = if params[:q]
        Product.where("name LIKE ?", "%#{params[:q]}%")
      else
        Product.all
      end.paginate(page: params[:page], per_page: 1)
    end

    def show
      render json: @product
    end
  
    def new
      @product = Product.new
    end
  
    def edit
    end
  
    def create
      @product = Product.new(product_params)

      day_of_month = Time.now.day
  
      if day_of_month >= 1 && day_of_month <= 15
        if @product.price > 5000
          @product.errors.add(:price, "Debe ser menor o igual a 5000 en los primeros 15 días del mes")
          render :new
          return
        end
      else
        if @product.price <= 5000
          @product.errors.add(:price, "Debe ser mayor a 5000 después del día 15 del mes")
          render :new
          return
        end
      end
  
      if @product.save
        redirect_to @product, notice: 'Producto creado exitosamente.'
      else
        render :new
      end
    end
  
    def update
      if @product.update(product_params)
        redirect_to @product, notice: 'Producto actualizado exitosamente.'
      else
        render :edit
      end
    end
  
    def destroy
      @product.destroy
      redirect_to products_url, notice: 'Producto eliminado exitosamente.'
    end

    private

    def set_product
      begin
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to products_path, alert: 'Producto no encontrado'
      end
    end
  
    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
  end
  