describe "Productos API" do

	# index
	describe "GET /categorias" do
		it "Devuelve todas las categorias" do
			bebidas = FactoryGirl.create :bebidas
			lacteos = FactoryGirl.create :lacteos

			get "/categorias", {}, {"Accept" => "application/json"}

			expect(response.status).to eq 200 #OK

			body = JSON.parse(response.body)
			categorias = body['categorias']

			nombres_categoria = categorias.map { |m| m["nombre"] }
      		imagenes_categoria = categorias.map { |m| m["imagen"] }

      		expect(nombres_categoria).to match_array(["Bebidas", "Lacteos" ])
      		expect(imagenes_categoria).to match_array(["imagen_bebidas.jpg", "imagen_lacteos.jpg" ])
      	end
	end

	# show
	describe "GET /categorias/:id" do
		it "Devuelve la informacion de la categoria con id :id"  do
			bebidas = FactoryGirl.create :bebidas

			get "/categorias/#{bebidas.id}", {}, { "Accept" => "application/json" }
			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			categoria = body['categoria']
			expect(categoria["nombre"]).to eq "Bebidas"
      		expect(categoria["imagen"]).to eq "imagen_bebidas.jpg"
      	end
	end

	# destroy
	describe "DELETE /categorias/:id" do
		it "Elimina la categoria con id :id" do
      		bebidas = FactoryGirl.create :bebidas

      		delete "/categorias/#{bebidas.id}", {}, { "Accept" => "application/json" }

      		expect(response.status).to be 204 # No Content
      		expect(Categoria.count).to eq 0
    end
	end

	# create
	describe "POST /categorias" do
		it "Crea una categoria" do 
			bebidas = FactoryGirl.create :bebidas

      		parametros_categoria = FactoryGirl.attributes_for(:bebidas).to_json

      		cabeceras_peticion = {
        	"Accept" => "application/json",
        	"Content-Type" => "application/json"
      		}

      		post "/categorias", parametros_categoria, cabeceras_peticion
      		expect(response.status).to eq 201 # Created
      		expect(Categoria.first.nombre).to eq bebidas.nombre
      		expect(Categoria.first.imagen).to eq bebidas.imagen
      	end
	end

	# update
	describe "PUT /categorias/:id" do
		it "Actualiza la categoria con id :id" do
			bebidas = FactoryGirl.create :bebidas 

			parametros_categoria = {
        	"nombre" => "Nombre Diferente",
        	"imagen" => "Otra_imagen.jpg",
      		}.to_json

      		cabeceras_peticion = {
        	"Accept" => "application/json",
        	"Content-Type" => "application/json"
      		}

      		put "/categorias/#{bebidas.id}", parametros_categoria, cabeceras_peticion

      		expect(response.status).to be 204 # No content

      		expect(Categoria.first.nombre).to eq "Nombre Diferente"
      		expect(Categoria.first.imagen).to eq "Otra_imagen.jpg"
      	end	
	end

end
