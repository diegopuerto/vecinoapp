describe "Productos API", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
    @jugo = FactoryGirl.create :jugo
    @leche = FactoryGirl.create :leche
  end

	# index
	describe "GET /productos" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/productos", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/productos", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve todos los productos" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/productos", {}, @cabeceras_peticion

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
	end

	# show
	describe "GET /productos/:id" do
    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Devuelve la informacion del producto con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/productos/#{@jugo.id}", {}, @cabeceras_peticion

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
	end

	# destroy
	describe "DELETE /productos/:id" do

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        delete "/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Elimina el producto con id :id" do
        expect(Producto.count).to eq 2

        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(Producto.count).to eq 1
      end
    end
	end

	# create
	describe "POST /productos" do

    before :each do
      @parametros_producto = FactoryGirl.attributes_for(:producto).to_json
      @producto_nuevo = FactoryGirl.build :producto
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        post "/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Crea un producto" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 201 # Created

        expect(Producto.last.nombre).to eq @producto_nuevo.nombre
        expect(Producto.last.diferenciador).to eq @producto_nuevo.diferenciador
        expect(Producto.last.marca).to eq @producto_nuevo.marca
        expect(Producto.last.presentacion).to eq @producto_nuevo.presentacion
        expect(Producto.last.precio).to eq @producto_nuevo.precio
        expect(Producto.last.imagen).to eq @producto_nuevo.imagen
      end
    end
	end

	# update
	describe "PUT /productos/:id" do

    before :each do
      @parametros_producto = FactoryGirl.attributes_for(:producto).to_json
      @producto_nuevo = FactoryGirl.build :producto
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        put "/productos/#{@jugo.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/productos/#{@jugo.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Actualiza el producto con id :id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        put "/productos/#{@jugo.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to be 204 # No content

        expect(Producto.find(@jugo.id).nombre).to eq @producto_nuevo.nombre
        expect(Producto.find(@jugo.id).diferenciador).to eq @producto_nuevo.diferenciador
        expect(Producto.find(@jugo.id).marca).to eq @producto_nuevo.marca
        expect(Producto.find(@jugo.id).presentacion).to eq @producto_nuevo.presentacion
        expect(Producto.find(@jugo.id).precio).to eq @producto_nuevo.precio
        expect(Producto.find(@jugo.id).imagen).to eq @producto_nuevo.imagen
      end	
    end
	end

end
