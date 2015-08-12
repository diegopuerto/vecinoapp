class UsuariosController < ApplicationController

  before_action :establecer_usuario, only: [:show]

  # GET /usuarios
  def index
    @usuarios = Usuario.all
    render json: @usuarios
  end

  # GET /usuarios/1
  def show
    render json: @usuario
  end

  private

    def establecer_usuario
      @usuario = Usuario.find(params[:id])
    end


end