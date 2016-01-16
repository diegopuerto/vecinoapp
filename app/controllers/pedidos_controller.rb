class PedidosController < ApplicationController

authorize_resource

	# GET /negocios/:negocio_id/pedidos
  	def index
  		if params[:usuario_pedido]
  			@usuario = Usuario.find(params[:usuario_id])
  			@usuario.pedidos.reload
  			render json: @usuario.pedidos
  		else
  			@negocio = Negocio.find(params[:negocio_id])
    		@negocio.pedidos.reload
    		render json: @negocio.pedidos
  		end
  	end

  	# GET /negocios/:negocio_id/pedidos/:id
  	def show
  		if params[:usuario_pedido]
  			@usuario = Usuario.find(params[:usuario_id])
  			@pedido = Pedido.find(params[:id])
  			render json: @usuario.pedidos.find(@pedido.id)
  		else
  			@negocio = Negocio.find(params[:negocio_id])
    		@pedido = Pedido.find(params[:id])
  			render json: @negocio.pedidos.find(@pedido.id)
  		end
  	end

  	# PATCH/PUT /negocios/:negocio_id/pedidos/:id
  	def update
  		if params[:usuario_pedido]
  			@usuario = Usuario.find(params[:usuario_id])
    		@pedido = Pedido.find(params[:id])
      		usuario_pedido = @usuario.pedidos.find(@pedido.id)
      			if usuario_pedido.update(parametros_actualizar_usuario_negocio)
        			head :no_content
      			else
        			render json: @usuario_pedido.errors, status: :unprocessable_entity
      			end
      	else
  			@negocio = Negocio.find(params[:negocio_id])
    		@pedido = Pedido.find(params[:id])
      		negocio_pedido = @negocio.pedidos.find(@pedido.id)
      			if negocio_pedido.update(parametros_actualizar_pedido_negocio)
        			head :no_content
      			else
        			render json: @negocio_pedido.errors, status: :unprocessable_entity
      			end
    	end
    end

    #POST /usuarios/:usuario_id/pedidos/
    def create
      if params[:usuario_pedido]
         @usuario = Usuario.find(params[:usuario_id])
         @pedido = Pedido.new (parametros_crear_usuario_pedido)
         @pedido.save
         if @pedido.update(parametros_crear_pedido_producto)
            head :no_content
         else 
            render json: @usuario_pedido.errors, status: :unprocessable_entity
         end
      else
        render json: @usuario_pedido.errors, status: :unprocessable_entity
      end
    end

    # DELETE /usuarios/:usuario_id/pedidos/:id
  	def destroy
  		if params[:usuario_pedido]
  			@usuario = Usuario.find(params[:usuario_id])
    		@pedido = Pedido.find(params[:id])
    		@usuario.pedidos.destroy(@pedido)
    		head :no_content
    	else
    		@negocio = Negocio.find(params[:negocio_id])
    		@pedido = Pedido.find(params[:id])
    		@negocio.pedidos.destroy(@pedido)
    		head :no_content
  		end
  	end

private
   
   	def parametros_actualizar_pedido_negocio
      	params.permit(:estado)
    end

    def parametros_actualizar_usuario_negocio
    	params.permit(:estado)
    end

    def parametros_crear_usuario_pedido
      params.permit(:propina,
        :comentario,
        :total,
        :estado,
        :medio_pago,
        :negocio_id,
        :direccion_id,
        :usuario_id)
    end

    def parametros_crear_pedido_producto
      params.permit(pedidos_productos_attributes: [:cantidad, :producto_id, :precio])
    end

end
