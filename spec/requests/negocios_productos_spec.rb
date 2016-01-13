describe "NegociosProductos API" do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
    @jugo = FactoryGirl.create :jugo
    @leche = FactoryGirl.create :leche
    @tienda = FactoryGirl.create :tienda
end


 # index
  describe "GET /negocios/:negocio_id/productos" do
    before :each do
      @tienda.productos << [@jugo, @leche]
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

          get "/negocios/#{@tienda.id}/productos", {}, @cabeceras_peticion

          expect(response.status).to eq 401 # Unauthorized
          expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do

          @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

          get "/negocios/#{@tienda.id}/productos", {}, @cabeceras_peticion

          expect(response.status).to eq 401 # Unauthorized
          expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

   context "usuario administrador autenticado" do

      it "Devuelve todos los productos del negocio con id :negocio_id" do
          # Login usuario_admin
          @cabeceras_peticion.merge! @admin.create_new_auth_token

          get "/negocios/#{@tienda.id}/productos", {}, @cabeceras_peticion

          expect(response.status).to eq 200 # OK

          body = JSON.parse(response.body)
          productos = body['productos']

          nombres_producto = productos.map { |m| m["nombre"] }
          imagenes_producto = productos.map { |m| m["imagen"] }

          expect(nombres_producto).to match_array([@jugo.nombre, @leche.nombre ]) 
          expect(imagenes_producto).to match_array([@jugo.imagen, @leche.imagen ])

      end
    end
  end

   # create
  describe "POST /negocios/:negocio_id/productos" do

    before :each do
      @parametros_producto = {
      "producto_id": @jugo.id,
      "precio": 10000
      }.to_json

      expect(@tienda.productos).not_to include(@jugo)
      end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        
        post "/negocios/#{@tienda.id}/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/negocios/#{@tienda.id}/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "Agrega un producto al negocio con id :negocio_id" do
        # Login usuario_admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/negocios/#{@tienda.id}/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@tienda.reload.productos).to include(@jugo)
      end
    end
  end

  # destroy

    describe "DELETE /negocios/:negocio_id/productos/:id" do

      before :each do
        @tienda.productos << @jugo
        expect(@tienda.reload.productos).to include(@jugo)
      end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        delete "/negocios/#{@tienda.id}/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/negocios/#{@tienda.id}/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end


    context "usuario administrador autenticado" do
      it "Quita el producto identificado con :id del negocio con id :negocio_id" do
        # Login usuario_admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/negocios/#{@tienda.id}/productos/#{@jugo.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@tienda.reload.productos.empty?).to be true
        expect(Producto.exists?(@jugo.id)).to be true
      end
    end
  end

  # update


  describe "PUT /negocios/:negocio_id/productos/:id" do

    before :each do
        @parametros_producto = {
        "producto_id": @jugo.id,
        "precio": 23400
        }.to_json

        @tienda.productos << @jugo
        expect(@tienda.reload.productos).to include(@jugo)
    end


    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        put "/negocios/#{@tienda.id}/productos/#{@jugo.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/negocios/#{@tienda.id}/productos/#{@jugo.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
        it "Actualiza el producto identificado con :id del negocio con id :negocio_id" do
          # Login usuario_admin
          @cabeceras_peticion.merge! @admin.create_new_auth_token

          put "/negocios/#{@tienda.id}/productos/#{@jugo.id}", @parametros_producto, @cabeceras_peticion

          expect(response.status).to be 204 # No Content

          np = NegocioProducto.find_by negocio_id: @tienda.id, producto_id: @jugo.id
          expect(NegocioProducto.find(np.id).precio).to eq 23400
        end
    end
  end
end