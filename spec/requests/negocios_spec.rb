describe "Negocios API" do

  # index
  describe "GET /negocios" do
    it "Devuelve todos los negocios" do
      tienda = FactoryGirl.create :tienda
      papeleria = FactoryGirl.create :papeleria

      get "/negocios", {}, { "Accept" => "application/json" }

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

  # show
  describe "GET /negocios/:id" do
    it "Devuelve la información del negocio con id :id" do
      tienda = FactoryGirl.create :tienda

      get "/negocios/#{tienda.id}", {}, { "Accept" => "application/json" }
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

  # destroy
  describe "DELETE /negocios/:id" do
    it "Elimina el negocio con id :id" do
      tienda = FactoryGirl.create :tienda

      delete "/negocios/#{tienda.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(Negocio.count).to eq 0
    end
  end

  # create
  describe "POST /negocios" do
    it "Crea un negocio" do
      tienda = FactoryGirl.create(:tienda)

      parametros_negocio = FactoryGirl.attributes_for(:tienda).to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/negocios", parametros_negocio, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(Negocio.first.nombre).to eq tienda.nombre
      expect(Negocio.first.direccion).to eq tienda.direccion
      expect(Negocio.first.latitud).to eq tienda.latitud
      expect(Negocio.first.longitud).to eq tienda.longitud
      expect(Negocio.first.reputacion).to eq tienda.reputacion
      expect(Negocio.first.tiempo_entrega).to eq tienda.tiempo_entrega
      expect(Negocio.first.pedido_minimo).to eq tienda.pedido_minimo
      expect(Negocio.first.recargo).to eq tienda.recargo
      expect(Negocio.first.tipo).to eq tienda.tipo
      expect(Negocio.first.cobertura).to eq tienda.cobertura
      expect(Negocio.first.telefono).to eq tienda.telefono
      expect(Negocio.first.imagen).to eq tienda.imagen
      expect(Negocio.first.activo).to eq tienda.activo
      expect(Negocio.first.hora_apertura).to eq tienda.hora_apertura
      expect(Negocio.first.hora_cierre).to eq tienda.hora_cierre
    end
  end

  # update 
  describe "PUT /negocios/:id" do
    it "Actualiza el negocio con id :id" do
      tienda = FactoryGirl.create :tienda

      parametros_negocio = {
        "nombre" => "Nombre Diferente",
        "direccion" => "carrera 4 # 5 - 4",
        "latitud" => 43,
        "longitud" => -12,
        "reputacion" => 400,
        "tiempo_entrega" => 45,
        "pedido_minimo" => 1000,
        "recargo" => 4000,
        "tipo" => "drogueria",
        "cobertura" => 5000,
        "telefono" => "3006654345",
        "imagen" => "nueva.jpg",
        "activo" => false,
        "hora_apertura" => "10:00 AM",
        "hora_cierre" => "03:00 PM",
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      put "/negocios/#{tienda.id}", parametros_negocio, cabeceras_peticion

      expect(response.status).to be 204 # No content

      expect(Negocio.first.nombre).to eq "Nombre Diferente"
      expect(Negocio.first.direccion).to eq "carrera 4 # 5 - 4"
      expect(Negocio.first.latitud).to eq 43
      expect(Negocio.first.longitud).to eq -12
      expect(Negocio.first.reputacion).to eq 400
      expect(Negocio.first.tiempo_entrega).to eq 45
      expect(Negocio.first.pedido_minimo.to_i).to eq 1000
      expect(Negocio.first.recargo.to_i).to eq 4000
      expect(Negocio.first.tipo).to eq "drogueria"
      expect(Negocio.first.cobertura).to eq 5000
      expect(Negocio.first.telefono).to eq "3006654345"
      expect(Negocio.first.imagen).to eq "nueva.jpg"
      expect(Negocio.first.activo).to eq false
      expect(Negocio.first.hora_apertura.strftime("%I:%M %p")).to eq "10:00 AM"
      expect(Negocio.first.hora_cierre.strftime("%I:%M %p")).to eq "03:00 PM"
    end
  end

end