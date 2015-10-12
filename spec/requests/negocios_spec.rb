describe "Negocios API", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
    @tienda = FactoryGirl.create :tienda
    @papeleria = FactoryGirl.create :papeleria
  end

  # index
  describe "GET /negocios" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/negocios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/negocios", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve todos los negocios" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/negocios", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        negocios = body['negocios']

        nombres_negocio = negocios.map { |m| m["nombre"] }
        direcciones_negocio = negocios.map { |m| m["direccion"] }
        latitudes_negocio = negocios.map { |m| m["latitud"] }
        longitudes_negocio = negocios.map { |m| m["longitud"] }
        reputaciones_negocio = negocios.map { |m| m["reputacion"] }
        tiempos_entrega_negocio = negocios.map { |m| m["tiempo_entrega"] }
        pedidos_minimos_negocio = negocios.map { |m| m["pedido_minimo"] }
        recargos_negocio = negocios.map { |m| m["recargo"] }
        tipos_negocio = negocios.map { |m| m["tipo"] }
        coberturas_negocio = negocios.map { |m| m["cobertura"] }
        telefonos_negocio = negocios.map { |m| m["telefono"] }
        imagenes_negocio = negocios.map { |m| m["imagen"] }
        activos_negocio = negocios.map { |m| m["activo"] }
        horas_apertura_negocio = negocios.map { |m| m["hora_apertura"] }
        horas_cierre_negocio = negocios.map { |m| m["hora_cierre"] }

        expect(nombres_negocio).to match_array(["Tienda Rspec", "Papeleria Rspec" ])
        expect(direcciones_negocio).to match_array(["Carrera 14 # 5 - 5", "Carrera 14 # 1 - 5" ])
        expect(latitudes_negocio).to match_array([1.5, 1.8 ])
        expect(longitudes_negocio).to match_array([-1.5, -7.5])
        expect(reputaciones_negocio).to match_array([1000, 1700])
        expect(tiempos_entrega_negocio).to match_array([15, 30])
        expect(pedidos_minimos_negocio).to match_array([30000, 2000])
        expect(recargos_negocio).to match_array([3000, 10000])
        expect(tipos_negocio).to match_array(["tienda", "papeleria"])
        expect(coberturas_negocio).to match_array([1000, 2000])
        expect(telefonos_negocio).to match_array(["4432211", "4432568"])
        expect(imagenes_negocio).to match_array(["imagen.png", ""])
        expect(activos_negocio).to match_array([false, false])
        expect(horas_apertura_negocio).to match_array(["05:56 AM", "05:56 AM"])
        expect(horas_cierre_negocio).to match_array(["11:56 PM", "11:56 PM"])
      end
    end
  end

  # show
  describe "GET /negocios/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/negocios/#{@tienda.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/negocios/#{@tienda.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end
    context "usuario administrador autenticado" do
      it "Devuelve la información del negocio con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/negocios/#{@tienda.id}", {}, @cabeceras_peticion

        expect(response.status).to be 200 # OK

        body = JSON.parse(response.body)
        negocio = body['negocio']
        expect(negocio["nombre"]).to eq "Tienda Rspec"
        expect(negocio["direccion"]).to eq "Carrera 14 # 5 - 5"
        expect(negocio["latitud"]).to eq 1.5
        expect(negocio["longitud"]).to eq -1.5
        expect(negocio["reputacion"]).to eq 1000
        expect(negocio["tiempo_entrega"]).to eq 15
        expect(negocio["pedido_minimo"]).to eq 30000
        expect(negocio["recargo"]).to eq 3000
        expect(negocio["tipo"]).to eq "tienda"
        expect(negocio["cobertura"]).to eq 1000
        expect(negocio["telefono"]).to eq "4432211"
        expect(negocio["imagen"]).to eq "imagen.png"
        expect(negocio["activo"]).to eq false
        expect(negocio["hora_apertura"]).to eq "05:56 AM"
        expect(negocio["hora_cierre"]).to eq "11:56 PM"
      end
    end
  end

  # destroy
  describe "DELETE /negocios/:id" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/negocios/#{@tienda.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/negocios/#{@tienda.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Elimina el negocio con id :id" do
        expect(Negocio.count).to eq 2

        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/negocios/#{@tienda.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(Negocio.count).to eq 1
      end
    end
  end

  # create
  describe "POST /negocios" do

    before :each do
      @parametros_negocio = FactoryGirl.attributes_for(:negocio_nuevo).to_json
      @negocio_nuevo = FactoryGirl.build :negocio_nuevo
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/negocios", @parametros_negocio, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/negocios", @parametros_negocio, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Crea un negocio" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/negocios", @parametros_negocio, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(Negocio.last.nombre).to eq @negocio_nuevo.nombre
      end
    end
  end

  # update
  describe "PUT /negocios/:id" do

    before :each do
      @parametros_negocio = FactoryGirl.attributes_for(:negocio_nuevo).to_json
      @negocio_nuevo = FactoryGirl.build :negocio_nuevo
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        put "/negocios/#{@tienda.id}", @parametros_negocio, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/negocios/#{@tienda.id}", @parametros_negocio, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Actualiza el negocio con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        put "/negocios/#{@tienda.id}", @parametros_negocio, @cabeceras_peticion

        expect(response.status).to be 204 # No content

        expect(Negocio.find(@tienda.id).nombre).to eq @negocio_nuevo.nombre
      end
    end
  end

end
