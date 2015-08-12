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

  private

    def establecer_usuario
      @usuario = Usuario.find(params[:id])
    end


end