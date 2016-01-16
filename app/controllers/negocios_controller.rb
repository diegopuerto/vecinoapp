class NegociosController < ApplicationController
	  before_action :establecer_negocio, only: [:show, :destroy, :update]
    authorize_resource
  # GET /negocios
  # GET /usuarios/:usuario_id/negocios_propios
  def index
    if params[:propietario]
      @negocios_propios = Usuario.find(params[:usuario_id]).negocios_propios
      render json: @negocios_propios,
        root: 'negocios_propios',
        each_serializer: NegocioPropioSerializer
    else
      @negocios = Negocio.all
      render json: @negocios
    end
  end

  # GET /negocios/1
  def show
    render json: @negocio
  end

  # DELETE /negocios/1
  # DELETE /usuarios/:usuario_id/negocios_propios/:id
  def destroy
    if params[:propietario]
      @propietario = Usuario.find(params[:usuario_id])
      @propietario.negocios_propios.destroy(@negocio)
      head :no_content
    else
      @negocio.destroy
      head :no_content
    end
  end

  # POST /negocios
  # POST /usuarios/:usuario_id/negocios_propios
  def create
    if params[:propietario]
      @negocio_propio = Negocio.find(params[:negocio_id])
      @propietario = Usuario.find(params[:usuario_id])
      if @propietario.negocios_propios << @negocio_propio
        render json: @propietario.negocios_propios, status: :created
      else
        render json: @propietario.negocios_propios.errors, status: :unprocessable_entity
      end
    else
      @negocio = Negocio.new(parametros_negocio)

      if @negocio.save
        render json: @negocio, status: :created
      else
        render json: @negocio.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /negocios/1
  def update
    if @negocio.update(parametros_negocio)
      head :no_content
    else
      render json: @neogocio.errors, status: :unprocessable_entity
    end
  end

  private

    def establecer_negocio
      @negocio = Negocio.find(params[:id])
    end

    def parametros_negocio
      params.permit(:nombre,
       :direccion,
       :latitud,
       :longitud,
       :reputacion,
       :tiempo_entrega,
       :pedido_minimo,
       :recargo,
       :tipo,
       :cobertura,
       :telefono,
       :imagen,
       :activo,
       :hora_apertura,
       :hora_cierre)
    end

end