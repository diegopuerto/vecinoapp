class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :validar_admin

  private

    def validar_admin
      unless current_usuario && current_usuario.es_admin?
        render json: { errors: "Acceso restringido. Solo Administradores"  }, status: :unauthorized
      end
    end
end
