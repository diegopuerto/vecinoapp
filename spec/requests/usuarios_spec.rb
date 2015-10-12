describe "Usuarios API" do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @usuario_dos = FactoryGirl.create :usuario_dos
    @admin = FactoryGirl.create :admin
  end

  # index
  describe "GET /usuarios" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/usuarios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/usuarios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve todos los usuarios" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/usuarios", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        usuarios = body['usuarios']
        correos_usuario = usuarios.map { |m| m["email"] }
        nombres_usuario = usuarios.map { |m| m["name"] }
        imagenes_usuario = usuarios.map { |m| m["image"] }
        telefonos_usuario = usuarios.map { |m| m["telefono"] }
        admins_usuario = usuarios.map { |m| m["es_admin"] }
        propietarios_usuario = usuarios.map { |m| m["es_propietario"] }

        expect(correos_usuario).to match_array([@usuario_uno.email, @usuario_dos.email, @admin.email])
        expect(nombres_usuario).to match_array([@usuario_uno.name, @usuario_dos.name, @admin.name])
        expect(imagenes_usuario).to match_array([@usuario_uno.image, @usuario_dos.image, @admin.image])
        expect(telefonos_usuario).to match_array([@usuario_uno.telefono, @usuario_dos.telefono, @admin.telefono])
        expect(admins_usuario).to match_array([@usuario_uno.es_admin, @usuario_dos.es_admin, @admin.es_admin])
        expect(propietarios_usuario).to match_array([@usuario_uno.es_propietario, @usuario_dos.es_propietario, @admin.es_propietario])
      end
    end
  end

  # show
  describe "GET /usuarios/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve el usuarios solicitado" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion
        expect(response.status).to be 200 # OK

        body = JSON.parse(response.body)
        usuario = body['usuario']
        expect(usuario["email"]).to eq @usuario_uno.email
        expect(usuario["name"]).to eq @usuario_uno.name
        expect(usuario["image"]).to eq @usuario_uno.image
        expect(usuario["telefono"]).to eq @usuario_uno.telefono
        expect(usuario["es_admin"]).to eq @usuario_uno.es_admin
        expect(usuario["es_propietario"]).to eq @usuario_uno.es_propietario
      end
    end
  end

  # destroy
  describe "DELETE /usuarios/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Elimina un usuario" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(Usuario.exists?(@usuario_uno.id)).to eq false
      end
    end
  end

  # create
  describe "POST /usuarios" do

    before :each do
      @parametros_usuario = FactoryGirl.attributes_for(:usuario_nuevo).to_json
      @usuario_nuevo = FactoryGirl.build :usuario_nuevo
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/usuarios", @parametros_usuario, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/usuarios", @parametros_usuario, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Crea un usuario" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/usuarios", @parametros_usuario, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(Usuario.last.email).to eq @usuario_nuevo.email
        expect(Usuario.last.name).to eq @usuario_nuevo.name
        expect(Usuario.last.image).to eq @usuario_nuevo.image
        expect(Usuario.last.telefono).to eq @usuario_nuevo.telefono
        expect(Usuario.last.es_admin).to eq @usuario_nuevo.es_admin
        expect(Usuario.last.es_propietario).to eq @usuario_nuevo.es_propietario
      end
    end
  end

  # update
  describe "PUT /usuarios/:id" do

    before :each do
      @parametros_usuario = FactoryGirl.attributes_for(:usuario_nuevo).to_json
      @usuario_nuevo = FactoryGirl.build :usuario_nuevo
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        put "/usuarios/#{@usuario_uno.id}", @parametros_usuario, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/usuarios/#{@usuario_uno.id}", @parametros_usuario, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Actualiza un usuario" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        put "/usuarios/#{@usuario_uno.id}", @parametros_usuario, @cabeceras_peticion

        # Solo se van a modificar cuatro parámetros desde el API RESTful
        #  email, name, image y telefono
        # El campo password solo lo podrá modificar el usuario por medio
        #  de un correo de recuperación de password 
        # El campo es_propietario lo establece el modelo al asociarse con
        #  un recurso negocio
        # El campo es_admin no es modificable
        expect(response.status).to be 204 # No content
        expect(Usuario.find(@usuario_uno.id).email).to eq @usuario_nuevo.email
        expect(Usuario.find(@usuario_uno.id).name).to eq @usuario_nuevo.name
        expect(Usuario.find(@usuario_uno.id).image).to eq @usuario_nuevo.image
        expect(Usuario.find(@usuario_uno.id).telefono).to eq @usuario_nuevo.telefono
        expect(Usuario.find(@usuario_uno.id).es_admin).to eq @usuario_uno.es_admin
        expect(Usuario.find(@usuario_uno.id).es_propietario).to eq @usuario_uno.es_propietario
      end
    end
  end

end
