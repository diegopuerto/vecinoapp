describe "CategoriasProductos API" do

  # index
  describe "GET /productos/:producto_id/categorias" do
    it "devuelve todos las categorias del producto con id :producto_id" do
      jugo = FactoryGirl.create :jugo,
        categorias: [FactoryGirl.create(:bebidas),
				        		 FactoryGirl.create(:lacteos)]

      cat = FactoryGirl.create :categoria

      get "/productos/#{jugo.id}/categorias", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200 # OK

      body = JSON.parse(response.body)
      categorias = body['categorias']

      nombres_categoria = categorias.map { |m| m["nombre"] }
      imagenes_categoria = categorias.map { |m| m["imagen"] }

      expect(nombres_categoria).to match_array(["Bebidas", "Lacteos" ])
      expect(imagenes_categoria).to match_array(["imagen_bebidas.jpg", "imagen_lacteos.jpg"])

    end
  end

  # create
  describe "POST /productos/:producto_id/categorias" do
    it "agrega una categoria al producto con id :producto_id" do
      jugo = FactoryGirl.create :jugo
      bebidas = FactoryGirl.create :bebidas

      expect(jugo.categorias).not_to include(bebidas)

      parametros_categoria = {
        "categoria_id": bebidas.id
      }.to_json

      cabeceras_peticion = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/productos/#{jugo.id}/categorias", parametros_categoria, cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(jugo.reload.categorias).to include(bebidas)
    end
  end

# destroy
  describe "DELETE /productos/:producto_id/categorias/:id" do
    it "quita la categoria identificada con :id del producto con id :producto_id" do
      jugo = FactoryGirl.create :jugo
      bebidas = FactoryGirl.create :bebidas

      jugo.categorias << bebidas

      expect(jugo.reload.categorias).to include(bebidas)

      delete "/productos/#{jugo.id}/categorias/#{bebidas.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to be 204 # No Content
      expect(jugo.reload.categorias.empty?).to be true
      expect(Categoria.exists?(bebidas.id)).to be true
    end
  end



end