class DireccionesController < ApplicationController
  authorize_resource
  before_action :establecer_direccion, only: [:show, :destroy, :update]
  before_action :establecer_usuario, only: [:index, :create]

  # GET /usuarios/:id/direcciones
  def index
    render json: @usuario.direcciones
  end

  # GET /usuarios/:id/direcciones/1
  def show
    render json: @direccion
  end

  # DELETE /usuarios/:id/direcciones/1
  def destroy
    @direccion.destroy
    head :no_content
  end
 
  # POST /usuarios/:id/direcciones
  def create
    @direccion = @usuario.direcciones.new(parametros_direccion)

    if @direccion.save
      render json: @direccion, status: :created
    else
      render json: @direccion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usuarios/:id/direcciones/1
  def update
    if @direccion.update(parametros_direccion)
      head :no_content
    else
      render json: @direccion.errors, status: :unprocessable_entity
    end
  end

  private

    def establecer_direccion
      @direccion = Direccion.find(params[:id])
    end

    def establecer_usuario
      @usuario = Usuario.find(params[:usuario_id])
    end

    def parametros_direccion
      params.permit(:nombre,
       :lat,
       :long,
       :texto,
       :detalles)
    end

end