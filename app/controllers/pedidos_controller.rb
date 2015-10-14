class PedidosController < ApplicationController

	before_action :establecer_negocio_pedido, only: [:show, :update]

	# GET /negocios/:negocio_id/pedidos
  	def index
  		@negocio = Negocio.find(params[:negocio_id])
    	# Actualizar colección de productos
    	@negocio.pedidos.reload
    	render json: @negocio.pedidos
  	end

  	# GET /negocios/:negocio_id/pedidos/:id
  	def show
  		render json: @negocio.pedidos.find(@pedido.id)
  	end

  	# PATCH/PUT /negocios/:negocio_id/pedidos/:id
  	def update
      	negocio_pedido = @negocio.pedidos.find(@pedido.id)
      	if negocio_pedido.update(parametros_actualizar_pedido_negocio)
        	head :no_content
      	else
        	render json: @negocio_pedido.errors, status: :unprocessable_entity
      	end
    end

private
   
   	def parametros_actualizar_pedido_negocio
      params.permit(:estado)
    end

    def establecer_negocio_pedido
    	@negocio = Negocio.find(params[:negocio_id])
    	@pedido = Pedido.find(params[:id])
    end
end
