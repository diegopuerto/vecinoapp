class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions
 # before_action :validar_admin

 rescue_from CanCan::AccessDenied do |exception|
      render json: { errors: "Acceso restringido. Solo Administradores"  }, status: :unauthorized
 end

  private

    def validar_admin
      unless current_usuario && current_usuario.es_admin?
        render json: { errors: "Acceso restringido. Solo Administradores"  }, status: :unauthorized
      end
    end

  def current_ability
      @current_ability ||= Ability.new(current_usuario)
  end


end
