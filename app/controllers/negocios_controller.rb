class NegociosController < ApplicationController
	  before_action :establecer_negocio, only: [:show, :destroy, :update]

  # GET /negocios
  def index
    @negocios = Negocio.all
    render json: @negocios
  end

  # GET /usuarios/1
  def show
    render json: @negocio
  end

  # DELETE /usuarios/1
  def destroy
    @negocio.destroy
    head :no_content
  end

  # POST /usuarios
  def create
    @negocio = Negocio.new(parametros_negocio)

    if @negocio.save
      render json: @negocio, status: :created
    else
      render json: @negocio.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usuarios/1
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