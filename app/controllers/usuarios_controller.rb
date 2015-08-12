class UsuariosController < ApplicationController

  # GET /usuarios
  def index
    @usuarios = Usuario.all
    render json: @usuarios
  end

end