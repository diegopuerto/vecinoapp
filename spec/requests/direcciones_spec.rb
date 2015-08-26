describe "Direcciones API" do

  # index
  describe "GET /usuarios/:id/direcciones" do
    it "Devuelve todas las direcciones del usuario con id :id" do
      u = FactoryGirl.create(:usuario_uno) do |usuario|
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_oficina))
      end

      get "/usuarios/#{u.id}/direcciones", {}, { "Accept" => "application/json" }

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

  # show
  describe "GET /usuarios/:id/direcciones/:id" do
    it "Devuelve la dirección solicitada del usuario con id :id" do
      u = FactoryGirl.create(:usuario_uno) do |usuario|
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
      end

      d = u.direcciones.first

      get "/usuarios/#{u.id}/direcciones/#{d.id}", {}, { "Accept" => "application/json" }
      expect(response.status).to be 200 # OK

      body = JSON.parse(response.body)
      direccion = body['direccion']
      expect(direccion["nombre"]).to eq "casa"
      expect(direccion["lat"]).to eq 1.5
      expect(direccion["long"]).to eq 1.1
      expect(direccion["texto"]).to eq "Calle 2 2 1"
      expect(direccion["detalles"]).to eq "por la bajada"
    end
  end

  # destroy
  describe "DELETE /usuarios/:id/direcciones/:id" do
    it "Elimina una dirección del usuario con id :id" do
      u = FactoryGirl.create(:usuario_uno) do |usuario|
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
      end

      d = u.direcciones.first

      delete "/usuarios/#{u.id}/direcciones/#{d.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(Direccion.count).to eq 0
    end
  end

  # create
  describe "POST /usuarios/:id/direcciones" do
    it "Crea una dirección para el usuario con id :id" do

      u = FactoryGirl.create(:usuario_uno)

      parametros_direccion = {
        "nombre" => "casa nueva",
        "lat" => 22,
        "long" => -43,
        "texto" => "carrera 4 2 1",
        "detalles" => "la casa grande",
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/usuarios/#{u.id}/direcciones", parametros_direccion, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(Direccion.first.nombre).to eq "casa nueva"
      expect(Direccion.first.lat).to eq 22
      expect(Direccion.first.long).to eq -43
      expect(Direccion.first.texto).to eq "carrera 4 2 1"
      expect(Direccion.first.detalles).to eq "la casa grande"

      d = u.direcciones.first

      get "/usuarios/#{u.id}/direcciones/#{d.id}", {}, { "Accept" => "application/json" }
      expect(response.status).to be 200 # OK

      body = JSON.parse(response.body)
      direccion = body['direccion']
      expect(direccion["nombre"]).to eq "casa nueva"
      expect(direccion["lat"]).to eq 22
      expect(direccion["long"]).to eq -43
      expect(direccion["texto"]).to eq "carrera 4 2 1"
      expect(direccion["detalles"]).to eq "la casa grande"
    end
  end

  # update
  describe "PUT /usuarios/:id/direcciones/:id" do
    it "Actualiza una direccion del usuario con id :id" do
      u = FactoryGirl.create(:usuario_uno) do |usuario|
        usuario.direcciones.create(FactoryGirl.attributes_for(:direccion_casa))
      end

      d = u.direcciones.first
      
      parametros_direccion = {
        "nombre" => "casa nueva",
        "lat" => 22,
        "long" => -43,
        "texto" => "carrera 4 2 1",
        "detalles" => "la casa grande",
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      put "/usuarios/#{u.id}/direcciones/#{d.id}", parametros_direccion, cabeceras_peticion

      expect(response.status).to be 204 # No content
      expect(Direccion.first.nombre).to eq "casa nueva"
      expect(Direccion.first.lat).to eq 22
      expect(Direccion.first.long).to eq -43
      expect(Direccion.first.texto).to eq "carrera 4 2 1"
      expect(Direccion.first.detalles).to eq "la casa grande"
    end
  end

end