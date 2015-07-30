class WelcomeController < ApplicationController

  def index
    @prueba = DateTime.now
    render json: @prueba
  end

end
