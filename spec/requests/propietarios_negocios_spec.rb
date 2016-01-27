describe "PropietariosNegocios API", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
    @usuario  = FactoryGirl.create :usuario_dos,
      negocios_propios: [FactoryGirl.create(:papeleria),
													 FactoryGirl.create(:tienda)]
    @papeleria = @usuario.negocios_propios.first
  end

  # index
  describe "GET /usuarios/:usuario_id/negocios_propios" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/usuarios/#{@usuario.id}/negocios_propios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/usuarios/#{@usuario.id}/negocios_propios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario.create_new_auth_token

        get "/usuarios/#{@usuario.id}/negocios_propios", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        negocios = body['negocios_propios']

        nombres_negocio = negocios.map { |m| m["nombre"] }
        direcciones_negocio = negocios.map { |m| m["direccion"] }
        latitudes_negocio = negocios.map { |m| m["latitud"] }
        longitudes_negocio = negocios.map { |m| m["longitud"] }
        tipos_negocio = negocios.map { |m| m["tipo"] }
        coberturas_negocio = negocios.map { |m| m["cobertura"] }
        activos_negocio = negocios.map { |m| m["activo"] }

        expect(nombres_negocio).to match_array(["Tienda Rspec", "Papeleria Rspec" ])
        expect(direcciones_negocio).to match_array(["Carrera 14 # 5 - 5", "Carrera 14 # 1 - 5" ])
        expect(latitudes_negocio).to match_array([1.5, 1.8 ])
        expect(longitudes_negocio).to match_array([-1.5, -7.5])
        expect(tipos_negocio).to match_array(["tienda", "papeleria"])
        expect(coberturas_negocio).to match_array([1000, 2000])
        expect(activos_negocio).to match_array([false, false])
      end
    end

    context "usuario administrador autenticado" do
      it "devuelve todos los negocios del usuario con id :usuario_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/usuarios/#{@usuario.id}/negocios_propios", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        negocios = body['negocios_propios']

        nombres_negocio = negocios.map { |m| m["nombre"] }
        direcciones_negocio = negocios.map { |m| m["direccion"] }
        latitudes_negocio = negocios.map { |m| m["latitud"] }
        longitudes_negocio = negocios.map { |m| m["longitud"] }
        tipos_negocio = negocios.map { |m| m["tipo"] }
        coberturas_negocio = negocios.map { |m| m["cobertura"] }
        activos_negocio = negocios.map { |m| m["activo"] }

        expect(nombres_negocio).to match_array(["Tienda Rspec", "Papeleria Rspec" ])
        expect(direcciones_negocio).to match_array(["Carrera 14 # 5 - 5", "Carrera 14 # 1 - 5" ])
        expect(latitudes_negocio).to match_array([1.5, 1.8 ])
        expect(longitudes_negocio).to match_array([-1.5, -7.5])
        expect(tipos_negocio).to match_array(["tienda", "papeleria"])
        expect(coberturas_negocio).to match_array([1000, 2000])
        expect(activos_negocio).to match_array([false, false])
      end
    end
  end

  # index
  describe "GET /negocios/:negocio_id/propietarios" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/negocios/#{@papeleria.id}/propietarios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/negocios/#{@papeleria.id}/propietarios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "devuelve todos los propietarios del negocio con id :negocio_id" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario.create_new_auth_token

        get "/negocios/#{@papeleria.id}/propietarios", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        usuarios = body['propietarios']

        correos_usuario = usuarios.map { |m| m["email"] }
        nombres_usuario = usuarios.map { |m| m["name"] }

        expect(correos_usuario).to match_array(["usuario2@correo.com"])
        expect(nombres_usuario).to match_array(["Usuario Dos"])
      end
    end

    context "usuario administrador autenticado" do
      it "devuelve todos los propietarios del negocio con id :negocio_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/negocios/#{@papeleria.id}/propietarios", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        usuarios = body['propietarios']

        correos_usuario = usuarios.map { |m| m["email"] }
        nombres_usuario = usuarios.map { |m| m["name"] }

        expect(correos_usuario).to match_array(["usuario2@correo.com"])
        expect(nombres_usuario).to match_array(["Usuario Dos"])
      end
    end
  end

  # create
  describe "POST /usuarios/:usuario_id/negocios_propios" do

    before :each do
      @usuario.negocios_propios.clear
      expect(@usuario.negocios_propios).not_to include(@tienda)
      @tienda = FactoryGirl.create :tienda
      @parametros_negocio_propio = {
        "negocio_id" => @tienda.id
      }.to_json
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/usuarios/#{@usuario.id}/negocios_propios", @parametros_negocio_propio, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado no dueño" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/usuarios/#{@usuario.id}/negocios_propios", @parametros_negocio_propio, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado dueño" do
      it "agrega un negocio a los negocios propios del usuario con id :id" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario.create_new_auth_token

        post "/usuarios/#{@usuario.id}/negocios_propios", @parametros_negocio_propio, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@usuario.reload.negocios_propios).to include(@tienda)
      end
    end

    context "usuario administrador autenticado" do
      it "agrega un negocio a los negocios propios del usuario con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/usuarios/#{@usuario.id}/negocios_propios", @parametros_negocio_propio, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@usuario.reload.negocios_propios).to include(@tienda)
      end
    end
  end

  # create
  describe "POST /negocios/:negocio_id/propietarios" do

    before :each do
      @papeleria.propietarios.clear
      expect(@papeleria.propietarios).not_to include(@usuario)
      @parametros_propietario = {
        "usuario_id" => @usuario.id
      }.to_json
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/negocios/#{@papeleria.id}/propietarios", @parametros_propietario, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/negocios/#{@papeleria.id}/propietarios", @parametros_propietario, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "agrega un usuario a los propietarios del negocio con id :id" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario.create_new_auth_token

        post "/negocios/#{@papeleria.id}/propietarios", @parametros_propietario, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@papeleria.reload.propietarios).to include(@usuario)
      end
    end

    context "usuario administrador autenticado" do
      it "agrega un usuario a los propietarios del negocio con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/negocios/#{@papeleria.id}/propietarios", @parametros_propietario, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@papeleria.reload.propietarios).to include(@usuario)
      end
    end
  end

  # destroy
  describe "DELETE /usuarios/:usuario_id/negocios_propios/:id" do

    before :each do
      expect(@usuario.reload.negocios_propios).to include(@papeleria)
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/usuarios/#{@usuario.id}/negocios_propios/#{@papeleria.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/usuarios/#{@usuario.id}/negocios_propios/#{@papeleria.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario.create_new_auth_token

        delete "/usuarios/#{@usuario.id}/negocios_propios/#{@papeleria.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@usuario.reload.negocios_propios).to_not include(@papeleria)
        expect(Negocio.exists?(@papeleria.id)).to be true
      end
    end

    context "usuario administrador autenticado" do
      it "quita el negocio propio :id de los negocios propios del usuario :usuario_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/usuarios/#{@usuario.id}/negocios_propios/#{@papeleria.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@usuario.reload.negocios_propios).to_not include(@papeleria)
        expect(Negocio.exists?(@papeleria.id)).to be true
      end
    end
  end

  # destroy
  describe "DELETE /negocios/:negocio_id/propietarios/:id" do

    before :each do
      expect(@papeleria.reload.propietarios).to include(@usuario)
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/negocios/#{@papeleria.id}/propietarios/#{@usuario.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado no dueño" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/negocios/#{@papeleria.id}/propietarios/#{@usuario.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end


     context "usuario no administrador autenticado dueño" do
      it "quita el propietario :id de los propietarios del negocio :negocio_id" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario.create_new_auth_token

        delete "/negocios/#{@papeleria.id}/propietarios/#{@usuario.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@papeleria.reload.propietarios.empty?).to be true
        expect(Usuario.exists?(@usuario.id)).to be true
      end
    end

    context "usuario administrador autenticado" do

    end
    context "usuario no administrador autenticado dueño" do
      it "quita el propietario :id de los propietarios del negocio :negocio_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/negocios/#{@papeleria.id}/propietarios/#{@usuario.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@papeleria.reload.propietarios.empty?).to be true
        expect(Usuario.exists?(@usuario.id)).to be true
      end
    end
   end
end
