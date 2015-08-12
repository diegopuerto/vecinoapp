class UsuariosController < ApplicationController

  before_action :establecer_usuario, only: [:show, :destroy]

  # GET /usuarios
  def index
    @usuarios = Usuario.all
    render json: @usuarios
  end

  # GET /usuarios/1
  def show
    render json: @usuario
  end

  # DELETE /usuarios/1
  def destroy
    @usuario.destroy
    head :no_content
  end

  # POST /usuarios
  def create
    @usuario = Usuario.new(parametros_usuario)

    if @usuario.save
      render json: @usuario, status: :created
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  private

    def establecer_usuario
      @usuario = Usuario.find(params[:id])
    end

    def parametros_usuario
      params.permit(:email,
       :password,
       :uid,
       :provider,
       :name,
       :image,
       :telefono)
    end


end