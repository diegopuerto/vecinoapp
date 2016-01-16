class UsuariosController < ApplicationController

  load_and_authorize_resource

  # GET /usuarios
  # GET /negocios/:negocio_id/propietarios
  def index
    if params[:negocio_propio]
      render json: Negocio.find(params[:negocio_id]).propietarios,
        root: 'propietarios',
        each_serializer: PropietarioSerializer
    else
      render json: @usuarios
    end
  end

  # GET /usuarios/1
  def show
    render json: @usuario
  end

  # DELETE /usuarios/1
  # DELETE /negocios/:negocio_id/propietarios/:id
  def destroy
    if params[:negocio_propio]
      @negocio_propio = Negocio.find(params[:negocio_id])
      @negocio_propio.propietarios.destroy(@usuario)
      head :no_content
    else
      @usuario.destroy
      head :no_content
    end
  end

  # POST /usuarios
  # POST /negocios/:negocio_id/propietarios
  def create
    if params[:negocio_propio]
      @propietario = Usuario.find(params[:usuario_id])
      @negocio_propio = Negocio.find(params[:negocio_id])
      if @negocio_propio.propietarios << @propietario
        render json: @negocio_propio.propietarios, status: :created
      else
        render json: @negocio_propio.propietarios.errors, status: :unprocessable_entity
      end
    else
       @usuario.update(parametros_crear_usuario)
      if @usuario.save
        render json: @usuario, status: :created
      else
        render json: @usuario.errors, status: :unprocessable_entity
      end 
    end
  end

  # PATCH/PUT /usuarios/1
  def update
    if @usuario.update(parametros_editar_usuario)
      head :no_content
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  private

    def parametros_crear_usuario
      params.permit(:email,
       :password,
       :uid,
       :provider,
       :name,
       :image,
       :telefono)
    end

    def parametros_editar_usuario
    	params.permit(:email,
    		:name,
    		:image,
    		:telefono)
    end

end