describe "Direcciones API", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
    @usuario = FactoryGirl.create(:usuario_dos) do |usuario|
      usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
      usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_oficina))
    end
  end

  # index
  describe "GET /usuarios/:id/direcciones" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/usuarios/#{@usuario.id}/direcciones", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token
        get "/usuarios/#{@usuario.id}/direcciones", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do
      it "Devuelve todas las direcciones del usuario con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/usuarios/#{@usuario.id}/direcciones", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        direcciones = body['direcciones']
        nombres_direccion = direcciones.map { |m| m["nombre"] }
        lat_direccion = direcciones.map { |m| m["lat"] }
        long_direccion = direcciones.map { |m| m["long"] }
        texto_direccion = direcciones.map { |m| m["texto"] }
        detalles_direccion = direcciones.map { |m| m["detalles"] }

        expect(nombres_direccion).to match_array(["casa", "oficina"])
        expect(lat_direccion).to match_array([1.5, -21.5])
        expect(long_direccion).to match_array([1.1, 4.1])
        expect(texto_direccion).to match_array(["Calle 2 2 1", "Carrera 3 2 1 of 301"])
        expect(detalles_direccion).to match_array(["por la bajada", ""])
      end
    end
  end

  # show
  describe "GET /usuarios/:id/direcciones/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do
      it "Devuelve la dirección solicitada del usuario con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to be 200 # OK

        body = JSON.parse(response.body)
        direccion = body['direccion']
        expect(direccion["nombre"]).to eq @usuario.direcciones.first.nombre
        expect(direccion["lat"]).to eq @usuario.direcciones.first.lat
        expect(direccion["long"]).to eq @usuario.direcciones.first.long
        expect(direccion["texto"]).to eq @usuario.direcciones.first.texto
        expect(direccion["detalles"]).to eq @usuario.direcciones.first.detalles
      end
    end
  end

  # destroy anidada en usuario
  describe "DELETE /usuarios/:id/direcciones/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Elimina una dirección del usuario con id :id" do
        expect(@usuario.direcciones.count).to be 2

        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@usuario.direcciones.count).to be 1
      end
    end
  end

  # destroy
  describe "DELETE /direcciones/:id" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Elimina una dirección de un usuario" do
        expect(@usuario.direcciones.count).to be 2

        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/direcciones/#{@usuario.direcciones.first.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@usuario.direcciones.count).to be 1
      end
    end
  end

  # create
  describe "POST /usuarios/:id/direcciones" do

    before :each do
      @direccion_nueva = FactoryGirl.build :direccion_nueva
      @parametros_direccion = FactoryGirl.attributes_for(:direccion_nueva).to_json
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/usuarios/#{@usuario.id}/direcciones", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/usuarios/#{@usuario.id}/direcciones", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Crea una dirección para el usuario con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/usuarios/#{@usuario.id}/direcciones", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@usuario.direcciones.last.nombre).to eq @direccion_nueva.nombre
      end
    end
  end

  # update anidada en usuario
  describe "PUT /usuarios/:id/direcciones/:id" do

    before :each do
      @parametros_direccion = FactoryGirl.attributes_for(:direccion_nueva).to_json
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        put "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Actualiza una direccion del usuario con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        put "/usuarios/#{@usuario.id}/direcciones/#{@usuario.direcciones.first.id}", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to be 204 # No content
        expect(@usuario.direcciones.first.nombre).to eq "casa nueva"
        expect(@usuario.direcciones.first.lat).to eq 22
        expect(@usuario.direcciones.first.long).to eq -43
        expect(@usuario.direcciones.first.texto).to eq "carrera 4 2 1"
        expect(@usuario.direcciones.first.detalles).to eq "la casa grande"
      end
    end
  end

  # update 
  describe "PUT /direcciones/:id" do

    before :each do
      @parametros_direccion = FactoryGirl.attributes_for(:direccion_nueva).to_json
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        put "/direcciones/#{@usuario.direcciones.first.id}", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/direcciones/#{@usuario.direcciones.first.id}", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Actualiza una direccion" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        put "/direcciones/#{@usuario.direcciones.first.id}", @parametros_direccion, @cabeceras_peticion

        expect(response.status).to be 204 # No content
        expect(@usuario.direcciones.first.nombre).to eq "casa nueva"
        expect(@usuario.direcciones.first.lat).to eq 22
        expect(@usuario.direcciones.first.long).to eq -43
        expect(@usuario.direcciones.first.texto).to eq "carrera 4 2 1"
        expect(@usuario.direcciones.first.detalles).to eq "la casa grande"
      end
    end
  end

end
