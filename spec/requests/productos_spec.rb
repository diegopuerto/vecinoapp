describe "Productos API" do

	# index
	describe "GET /productos" do
		it "Devuelve todos los productos" do 
			jugo = FactoryGirl.create :jugo
			leche = FactoryGirl.create :leche

			get "/productos", {}, {"Accept" => "application/json"}

			expect(response.status).to eq 200 #OK

			body = JSON.parse(response.body)
			productos = body['productos']

			nombres_producto = productos.map { |m| m["nombre"] }
      		diferenciadores_producto = productos.map { |m| m["diferenciador"] }
      		marcas_producto = productos.map { |m| m["marca"] }
      		presentaciones_producto = productos.map { |m| m["presentacion"] }
      		precios_producto = productos.map { |m| m["precio"] }
      		imagenes_producto = productos.map { |m| m["imagen"] }

      		expect(nombres_producto).to match_array(["Jugo del Valle", "Alqueria" ])
      		expect(diferenciadores_producto).to match_array(["Naranja", "Deslactosada" ])
      		expect(marcas_producto).to match_array(["Del Valle", "Alqueria" ])
      		expect(presentaciones_producto).to match_array(["300 ml", "1100 ml"])
      		expect(precios_producto).to match_array([2000, 2000])
      		expect(imagenes_producto).to match_array(["jugodelvallenaranja.jpg", "alqueriadeslactosada.jpg"])
		end
	end

	# show
	describe "GET /productos/:id" do
		it "Devuelve la informacion del producto con id :id" do
			jugo = FactoryGirl.create :jugo

			get "/productos/#{jugo.id}", {}, { "Accept" => "application/json" }
			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			producto = body['producto']
			expect(producto["nombre"]).to eq "Jugo del Valle"
      		expect(producto["diferenciador"]).to eq "Naranja"
      		expect(producto["marca"]).to eq "Del Valle"
      		expect(producto["presentacion"]).to eq "300 ml"
      		expect(producto["precio"]).to eq 2000
      		expect(producto["imagen"]).to eq "jugodelvallenaranja.jpg"
      	end
	end

	# destroy
	describe "DELETE /productos/:id" do
		it "Elimina el producto con id :id" do
			jugo = FactoryGirl.create :jugo

			delete "/productos/#{jugo.id}", {}, {"Accept" => "application/json"}
			
			expect(response.status).to be 204 # No Content
      		expect(Producto.count).to eq 0
      	end
	end

	# create
	describe "POST /productos" do
		it "Crea un producto" do 
			jugo = FactoryGirl.create :jugo

      		parametros_producto = FactoryGirl.attributes_for(:jugo).to_json

      		cabeceras_peticion = {
        	"Accept" => "application/json",
        	"Content-Type" => "application/json"
      		}

      		post "/productos", parametros_producto, cabeceras_peticion
      		expect(response.status).to eq 201 # Created
      		expect(Producto.first.nombre).to eq jugo.nombre
      		expect(Producto.first.diferenciador).to eq jugo.diferenciador
      		expect(Producto.first.marca).to eq jugo.marca
      		expect(Producto.first.presentacion).to eq jugo.presentacion
      		expect(Producto.first.precio).to eq jugo.precio
      		expect(Producto.first.imagen).to eq jugo.imagen
      	end
	end

	# update
	describe "PUT /productos/:id" do
		it "Actualiza el producto con id :id" do
			jugo = FactoryGirl.create :jugo 

			parametros_producto = {
        	"nombre" => "Nombre Diferente",
        	"diferenciador" => "Otro diferenciador",
        	"marca" => "Procter & Gamble",
        	"presentacion" => "1150 ml",
        	"precio" => 10000,
        	"imagen" => "Otra_imagen.jpg",
      		}.to_json

      		cabeceras_peticion = {
        	"Accept" => "application/json",
        	"Content-Type" => "application/json"
      		}

      		put "/productos/#{jugo.id}", parametros_producto, cabeceras_peticion

      		expect(response.status).to be 204 # No content

      		expect(Producto.first.nombre).to eq "Nombre Diferente"
      		expect(Producto.first.diferenciador).to eq "Otro diferenciador"
      		expect(Producto.first.marca).to eq "Procter & Gamble"
      		expect(Producto.first.presentacion).to eq "1150 ml"
      		expect(Producto.first.precio).to eq 10000
      		expect(Producto.first.imagen).to eq "Otra_imagen.jpg"
      	end	
	end

end