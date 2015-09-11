describe "PropietariosNegocios API" do

  # index
  describe "GET /usuarios/:usuario_id/negocios_propios" do
    it "devuelve todos los negocios del usuario con id :usuario_id" do
      u = FactoryGirl.create :usuario_uno,
      negocios_propios: [FactoryGirl.create(:papeleria),
													 FactoryGirl.create(:tienda)]
      get "/usuarios/#{u.id}/negocios_propios", {}, { "Accept" => "application/json" }

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

  # index
  describe "GET /negocios/:negocio_id/propietarios" do
    it "devuelve todos los propietarios del negocio con id :negocio_id" do
      n = FactoryGirl.create :tienda,
        propietarios: [FactoryGirl.create(:usuario_uno),
	
      FactoryGirl.create(:usuario_dos)]

      get "/negocios/#{n.id}/propietarios", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200 # OK

      body = JSON.parse(response.body)
      usuarios = body['propietarios']

      correos_usuario = usuarios.map { |m| m["email"] }
      nombres_usuario = usuarios.map { |m| m["name"] }

      expect(correos_usuario).to match_array(["usuario1@correo.com", "usuario2@correo.com"])
      expect(nombres_usuario).to match_array(["Usuario Uno", "Usuario Dos"])
    end
  end

  # create
  describe "POST /usuarios/:usuario_id/negocios_propios" do
    it "agrega un negocio a los negocios propios del usuario con id :id" do
      u = FactoryGirl.create(:usuario_uno)
      n = FactoryGirl.create(:tienda)

      expect(u.negocios_propios).not_to include(n)

      parametros_negocio_propio = {
        "negocio_id" => n.id
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/usuarios/#{u.id}/negocios_propios", parametros_negocio_propio, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(u.reload.negocios_propios).to include(n)
    end
  end

  # create
  describe "POST /negocios/:negocio_id/propietarios" do
    it "agrega un usuario a los propietarios del negocio con id :id" do
      u = FactoryGirl.create(:usuario_uno)
      n = FactoryGirl.create(:tienda)

      expect(n.propietarios).not_to include(u)

      parametros_propietario = {
        "usuario_id" => u.id
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/negocios/#{n.id}/propietarios", parametros_propietario, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(n.reload.propietarios).to include(u)
    end
  end

  # destroy
  describe "DELETE /usuarios/:usuario_id/negocios_propios/:id" do
    it "quita el negocio propio :id de los negocios propios del usuario :usuario_id" do
      u = FactoryGirl.create :usuario_uno
      n = FactoryGirl.create :tienda

      u.negocios_propios << n

      expect(u.reload.negocios_propios).to include(n)

      delete "/usuarios/#{u.id}/negocios_propios/#{n.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(u.reload.negocios_propios.empty?).to be true
      expect(Negocio.exists?(n.id)).to be true
    end
  end

  # destroy
  describe "DELETE /negocios/:negocio_id/propietarios/:id" do
    it "quita el propietario :id de los propietarios del negocio :negocio_id" do
      u = FactoryGirl.create :usuario_uno
      n = FactoryGirl.create :tienda

      n.propietarios << u

      expect(n.reload.propietarios).to include(u)

      delete "/negocios/#{n.id}/propietarios/#{u.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(n.reload.propietarios.empty?).to be true
      expect(Usuario.exists?(u.id)).to be true
    end
  end
end