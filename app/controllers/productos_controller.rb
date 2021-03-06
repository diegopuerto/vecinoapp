class ProductosController < ApplicationController

    load_resource

# GET /pedidos/:pedido_id/productos
# GET /negocios/:negocio_id/productos
# GET /productos
  def index
    if params[:pedido_producto]
      @pedido = Pedido.find(params[:pedido_id])
      authorize! :read, @pedido
      @pedido.productos.reload
      render json: @pedido.productos.con_precio

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      # Actualizar colección de productos
      authorize! :read, @negocio
      @negocio.productos.reload
      render json: @negocio.productos.con_precio
    else
      authorize! :read, @producto
      render json: @productos
    end
  end

# GET /pedidos/:pedido_id/productos/:producto_id
# GET /pedidos/:negocio_id/productos/:producto_id
# GET /productos/1
  def show
    if params[:pedido_producto]
      @pedido = Pedido.find(params[:pedido_id])
      authorize! :read, @pedido
      @producto = Producto.find(params[:id])
      render json: @pedido.productos.find(@producto.id)
    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      authorize! :read, @negocio
      @negocio.productos.reload
      np = NegocioProducto.find_by negocio_id: @negocio.id, producto_id: params[:id]
      @producto.precio = np.precio
      render json: @producto
    else
      authorize! :read, @producto
      render json: @producto
    end
  end


# DELETE /pedidos/:pedido_id/productos
# DELETE /negocios/:negocio_id/productos
# DELETE /productos
  def destroy
    if params[:pedido_producto]
      @pedido = Pedido.find(params[:pedido_id])
      authorize! :update, @pedido
      @pedido.productos.destroy(@producto)
      head :no_content

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      authorize! :update, @negocio
      @negocio.productos.destroy(@producto)
      head :no_content
    else
      authorize! :destroy, @producto
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
      @pedido = Pedido.find(params[:pedido_id])
      authorize! :update, @pedido
      @producto = Producto.find(params[:producto_id])
      @negocio = @pedido.negocio_id 
      pn = NegocioProducto.find_by negocio_id: @negocio, producto_id: @producto.id
      pp.precio = pn.precio
      if pp.save!
        render json: pp, status: :created
      else
        render json: {:errors => {producto: ["No se ha podido agregar producto"]}}, status: :unprocessable_entity
      end

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      authorize! :update, @negocio
      np = NegocioProducto.new parametros_crear_producto_negocio
      if np.save
        render json: np, status: :created
      else
        render json: {:errors => {producto: ["No se ha podido agregar producto"]}}, status: :unprocessable_entity
      end
    else
      authorize! :create, @producto
      @producto.update(parametros_producto)
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
      authorize! :update, @pedido
      @producto = Producto.find(params[:id])
      pp = PedidoProducto.find_by pedido_id: @pedido.id, producto_id: @producto.id
      if pp.update(parametros_actualizar_pedido_producto)
        head :no_content
      else
        render json: @pp.errors, status: :unprocessable_entity
      end

    elsif params[:negocio_producto]
      @negocio = Negocio.find(params[:negocio_id])
      authorize! :update, @negocio
      np = NegocioProducto.find_by negocio_id: @negocio.id, producto_id: @producto.id 
      if np.update(parametros_actualizar_producto_negocio)
        head :no_content
      else
        render json: @np.errors, status: :unprocessable_entity
      end

    else  
      authorize! :update, @producto
      if @producto.update(parametros_producto)
        head :no_content
      else
        render json: @producto.errors, status: :unprocessable_entity
      end
    end
  end


	private

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
        :cantidad)
    end

    def parametros_actualizar_producto_negocio
      params.permit(:precio)
    end

    def parametros_actualizar_pedido_producto
      params.permit(:cantidad)
    end
end
