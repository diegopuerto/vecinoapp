class CategoriasController < ApplicationController
	before_action :establecer_categoria, only: [:show, :destroy, :update]

	# GET /categorias
	def index
		@categorias = Categoria.all
    	render json: @categorias
	end

	# GET /productos/1
  	def show
    render json: @categoria
  	end

  	def destroy
  	@categoria.destroy
    head :no_content
  	end

  	def create
  	@categoria = Categoria.new(parametros_categoria)

  	if @categoria.save
      render json: @categoria, status: :created
    else
      render json: @categoria.errors, status: :unprocessable_entity
    end
  	end

  	# PATCH/PUT /productos/1
  	def update
    if @categoria.update(parametros_categoria)
       head :no_content #Con esta linea obtenemos una respuesta HTTP 204
    else
      render json: @categoria.errors, status: :unprocessable_entity
    end
  	end

	private

    def establecer_categoria
      @categoria = Categoria.find(params[:id])
    end

    def parametros_categoria
    	params.permit(:nombre,
       :imagen)
    end
end
