describe "Categorias API", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @bebidas = FactoryGirl.create :bebidas
    @lacteos = FactoryGirl.create :lacteos
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
  end

	# index
	describe "GET /categorias" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve todas las categorias" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 200 #OK

        body = JSON.parse(response.body)
        categorias = body['categorias']

        nombres_categoria = categorias.map { |m| m["nombre"] }
        imagenes_categoria = categorias.map { |m| m["imagen"] }

        expect(nombres_categoria).to match_array(["Bebidas", "Lacteos" ])
        expect(imagenes_categoria).to match_array(["imagen_bebidas.jpg", "imagen_lacteos.jpg" ])
      end
    end
	end

	# show
	describe "GET /categorias/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve la informacion de la categoría con id :id"  do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 200 #OK
        body = JSON.parse(response.body)

        categoria = body['categoria']
        expect(categoria["nombre"]).to eq "Bebidas"
        expect(categoria["imagen"]).to eq "imagen_bebidas.jpg"
      end
    end
	end

	# destroy
	describe "DELETE /categorias/:id" do

    before :each do
      Categoria.destroy_all
      @bebidas = FactoryGirl.create :bebidas
      expect(Categoria.count).to eq 1
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Elimina la categoria con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(Categoria.count).to eq 0
      end
    end
	end

	# create
	describe "POST /categorias" do

    before :each do
      Categoria.destroy_all
      @parametros_categoria = FactoryGirl.attributes_for(:bebidas).to_json
      @bebidas = FactoryGirl.build :bebidas
      expect(Categoria.exists?(@bebidas.id)).to be false
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Crea una categoria" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 201 # Created

        expect(Categoria.first.nombre).to eq @bebidas.nombre
        expect(Categoria.first.imagen).to eq @bebidas.imagen
      end
    end
	end

	# update
	describe "PUT /categorias/:id" do

    before :each do
      @parametros_categoria = {
        "nombre" => "Nombre Diferente",
        "imagen" => "Otra_imagen.jpg",
      }.to_json
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
      put "/categorias/#{@bebidas.id}", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/categorias/#{@bebidas.id}", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Actualiza la categoria con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        put "/categorias/#{@bebidas.id}", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to be 204 # No content

        expect(Categoria.find(@bebidas.id).nombre).to eq "Nombre Diferente"
        expect(Categoria.find(@bebidas.id).imagen).to eq "Otra_imagen.jpg"
      end
    end
	end

end
