describe "NegociosProductos API" do

 # index
 describe "GET /negocios/:negocio_id/productos" do
    it "Devuelve todos los productos del negocio con id :negocio_id" do
      tienda = FactoryGirl.create :tienda,
               productos: [FactoryGirl.create(:leche),
				                   FactoryGirl.create(:jugo)]

      #pro = FactoryGirl.create :producto

      get "/negocios/#{tienda.id}/productos", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200 # OK

      body = JSON.parse(response.body)
      productos = body['productos']

      nombres_producto = productos.map { |m| m["nombre"] }
      imagenes_producto = productos.map { |m| m["imagen"] }

      expect(nombres_producto).to match_array(["Jugo del Valle", "Alqueria" ])
      expect(imagenes_producto).to match_array(["jugodelvallenaranja.jpg", "alqueriadeslactosada.jpg"])

    end
  end

   # create
  describe "POST /negocios/:negocio_id/productos" do
    it "Agrega un producto al negocio con id :negocio_id" do
      tienda = FactoryGirl.create :tienda
      jugo = FactoryGirl.create :jugo

      expect(tienda.productos).not_to include(jugo)

      parametros_producto = {
        "producto_id": jugo.id,
        "precio": 10000
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/negocios/#{tienda.id}/productos", parametros_producto, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(tienda.reload.productos).to include(jugo)
    end
  end

  # destroy
  describe "DELETE /negocios/:negocio_id/productos/:id" do
    it "Quita el producto identificado con :id del negocio con id :negocio_id" do
      tienda = FactoryGirl.create :tienda
      jugo = FactoryGirl.create :jugo

      tienda.productos << jugo

      expect(tienda.reload.productos).to include(jugo)

      delete "/negocios/#{tienda.id}/productos/#{jugo.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(tienda.reload.productos.empty?).to be true
      expect(Producto.exists?(jugo.id)).to be true
    end
  end

  # destroy
  describe "PUT /negocios/:negocio_id/productos/:id" do
    it "Actualiza el producto identificado con :id del negocio con id :negocio_id" do
      tienda = FactoryGirl.create :tienda
      jugo = FactoryGirl.create :jugo

      tienda.productos << jugo

      expect(tienda.reload.productos).to include(jugo)

      parametros_producto = {
        "precio": 23400
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      put "/negocios/#{tienda.id}/productos/#{jugo.id}", parametros_producto, cabeceras_peticion

      expect(response.status).to be 204 # No Content
      expect(tienda.reload.productos.find(jugo.id).precio).to eq 23400

    end
  end
 end