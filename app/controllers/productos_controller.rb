class ProductosController < ApplicationController
		before_action :establecer_producto, only: [:show, :destroy, :update]


	# GET /productos
	def index
		@productos = Producto.all
    render json: @productos
	end

	# GET /productos/1
  def show
  	#@producto = Producto.find(params[:id])
    render json: @producto
  end

  def destroy
  	#@producto = Producto.find(params[:id])
  	@producto.destroy
    head :no_content
  end

  def create
  	@producto = Producto.new(parametros_producto)

  	if @producto.save
      render json: @producto, status: :created
    else
      render json: @producto.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /productos/1
  def update
    if @producto.update(parametros_producto)
      head :no_content
    else
      render json: @producto.errors, status: :unprocessable_entity
    end
  end

	private

    def establecer_producto
      @producto = Producto.find(params[:id])
    end

    def parametros_producto
    	params.permit(:nombre,
       :diferenciador,
       :marca,
       :presentacion,
       :precio,
       :imagen)
    end

end
