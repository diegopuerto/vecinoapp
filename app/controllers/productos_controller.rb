class ProductosController < ApplicationController
		before_action :establecer_producto, only: [:show, :destroy, :update]

# GET /pedidos/:pedido_id/productos
# GET /negocios/:negocio_id/productos
# GET /productos
  def index
    if params[:pedido_producto]
      @pedido = Pedido.find(params[:pedido_id])
      @pedido.productos.reload
      render json: @pedido.productos

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      # Actualizar colección de productos
      @negocio.productos.reload
      render json: @negocio.productos.con_precio
    else
      @productos = Producto.all
      render json: @productos
    end
  end
# GET /pedidos/:pedido_id/productos/:producto_id
# GET /productos/1
  def show
    if params[:pedido_producto]
      @pedido = Pedido.find(params[:pedido_id])
      @producto = Producto.find(params[:id])
      render json: @pedido.productos.find(@producto.id)
    else
  	#@producto = Producto.find(params[:id])
    render json: @producto
    end
  end

# DELETE /pedidos/:pedido_id/productos
# DELETE /negocios/:negocio_id/productos
# DELETE /productos
  def destroy
    if params[:pedido_producto]
      @producto = Producto.find(params[:id])
      @pedido = Pedido.find(params[:pedido_id])
      @pedido.productos.destroy(@producto)
      head :no_content

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      @negocio.productos.destroy(@producto)
      head :no_content
    else
  	  @producto.destroy
      head :no_content
    end
  end

  # POST /pedidos/:pedido_id/productos
  # POST /negocios/:negocio_id/productos
  # POST /productos
  def create
    if params[:pedido_producto]
      pp = PedidoProducto.new parametros_crear_pedido_producto
      if pp.save
        render json: pp, status: :created
      else
        render json: {:errors => {producto: ["No se ha podido agregar producto"]}}, status: :unprocessable_entity
      end

      elsif params[:negocio_producto]
        np = NegocioProducto.new parametros_crear_producto_negocio
        if np.save
          render json: np, status: :created
        else
          render json: {:errors => {producto: ["No se ha podido agregar producto"]}}, status: :unprocessable_entity
        end
      else
  	    @producto = Producto.new(parametros_producto)
        if @producto.save
          render json: @producto, status: :created
        else
          render json: @producto.errors, status: :unprocessable_entity
        end
      end
  end

  # PATCH/PUT /productos/1
  def update
    if params[:pedido_producto]
      @pedido = Pedido.find(params[:pedido_id])
      @producto = Producto.find(params[:id])
      pp = PedidoProducto.find_by pedido_id: @pedido.id, producto_id: @producto.id
      if pp.update(parametros_actualizar_pedido_producto)
        head :no_content
      else
        render json: @pp.errors, status: :unprocessable_entity
      end

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      np = @negocio.productos.find(@producto.id)
      if np.update(parametros_actualizar_producto_negocio)
        head :no_content
      else
        render json: @np.errors, status: :unprocessable_entity
      end

    else  
      if @producto.update(parametros_producto)
        head :no_content
      else
        render json: @producto.errors, status: :unprocessable_entity
      end
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

    def parametros_crear_producto_negocio
      params.permit(:negocio_id,
        :producto_id,
        :precio)
    end

    def parametros_crear_pedido_producto
        params.permit(:pedido_id,
        :producto_id,
        :precio,
        :cantidad)
    end

    def parametros_actualizar_producto_negocio
      params.permit(:precio)
    end

    def parametros_actualizar_pedido_producto
      params.permit(:cantidad)
    end
end
