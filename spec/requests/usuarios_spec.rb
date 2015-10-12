describe "Usuarios API" do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
  end

  # index
  describe "GET /usuarios" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do

    end
    it "Devuelve todos los usuarios" do
      FactoryGirl.create :usuario_uno
      FactoryGirl.create :usuario_dos

      get "/usuarios", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200 # OK

      body = JSON.parse(response.body)
      usuarios = body['usuarios']
      correos_usuario = usuarios.map { |m| m["email"] }
      nombres_usuario = usuarios.map { |m| m["name"] }
      imagenes_usuario = usuarios.map { |m| m["image"] }
      telefonos_usuario = usuarios.map { |m| m["telefono"] }
      admins_usuario = usuarios.map { |m| m["es_admin"] }
      propietarios_usuario = usuarios.map { |m| m["es_propietario"] }

      expect(correos_usuario).to match_array(["usuario1@correo.com", "usuario2@correo.com"])
      expect(nombres_usuario).to match_array(["Usuario Uno", "Usuario Dos"])
      expect(imagenes_usuario).to match_array(["usuario1.png", "usuario2.png"])
      expect(telefonos_usuario).to match_array(["3004560987", "3006785432"])
      expect(admins_usuario).to match_array([false, false])
      expect(propietarios_usuario).to match_array([false, false])
    end
  end
 
  # show
  describe "GET /usuarios/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do

    end
    it "Devuelve el usuarios solicitado" do
      u = FactoryGirl.create :usuario_uno

      get "/usuarios/#{u.id}", {}, { "Accept" => "application/json" }
      expect(response.status).to be 200 # OK

      body = JSON.parse(response.body)
      usuario = body['usuario']
      expect(usuario["email"]).to eq "usuario1@correo.com"
      expect(usuario["name"]).to eq "Usuario Uno"
      expect(usuario["image"]).to eq "usuario1.png"
      expect(usuario["telefono"]).to eq "3004560987"
      expect(usuario["es_admin"]).to eq false
      expect(usuario["es_propietario"]).to eq false
    end
  end

  # destroy
  describe "DELETE /usuarios/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do

    end
    it "Elimina un usuario" do
      u = FactoryGirl.create :usuario_uno

      delete "/usuarios/#{u.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(Usuario.count).to eq 0
    end
  end

  # create
  describe "POST /usuarios" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do

    end
    it "Crea un usuario" do
      parametros_usuario = {
        "email" => "usuario@correo.com",
        "password" => "clavesecreta",
        "uid" => "usuario@correo.com",
        "provider" => "email",
        "name" => "Usuario Uno",
        "image" => "usuario1.png",
        "telefono" => "3004560987"
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/usuarios", parametros_usuario, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(Usuario.first.email).to eq "usuario@correo.com"
      expect(Usuario.first.name).to eq "Usuario Uno"
      expect(Usuario.first.image).to eq "usuario1.png"
      expect(Usuario.first.telefono).to eq "3004560987"
      expect(Usuario.first.es_admin).to eq false
      expect(Usuario.first.es_propietario).to eq false
    end
  end

  # update
  describe "PUT /usuarios/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do

    end
    it "Actualiza un usuario" do
      u = FactoryGirl.create :usuario_uno

      parametros_usuario = {
        "email" => "otro@correo.com",
        "password" => "nuevosecreto",
        "name" => "usuario modificado",
        "image" => "nueva.png",
        "telefono" => "3001112233",
        "es_admin" => true,
        "es_propietario" => true

      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      put "/usuarios/#{u.id}", parametros_usuario, cabeceras_peticion

      # Solo se van a modificar cuatro parámetros desde el API RESTful
      #  email, name, image y telefono
      # El campo password solo lo podrá modificar el usuario por medio
      #  de un correo de recuperación de password 
      # El campo es_propietario lo establece el modelo al asociarse con
      #  un recurso negocio
      # El campo es_admin no es modificable
      expect(response.status).to be 204 # No content
      expect(Usuario.first.email).to eq "otro@correo.com"
      expect(Usuario.first.name).to eq "usuario modificado"
      expect(Usuario.first.image).to eq "nueva.png"
      expect(Usuario.first.telefono).to eq "3001112233"
      expect(Usuario.first.es_admin).to eq false
      expect(Usuario.first.es_propietario).to eq false
    end
  end

end
