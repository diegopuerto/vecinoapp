describe "CategoriasProductos API", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @jugo = FactoryGirl.create :jugo,
      categorias: [FactoryGirl.create(:bebidas),
                   FactoryGirl.create(:lacteos)]
    @bebidas = FactoryGirl.create :bebidas
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
  end

  # index
  describe "GET /productos/:producto_id/categorias" do

    before :each do
      @otra_categoria = FactoryGirl.create :categoria
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/productos/#{@jugo.id}/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/productos/#{@jugo.id}/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "devuelve todas las categorías del producto con id :producto_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/productos/#{@jugo.id}/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        categorias = body['categorias']

        nombres_categoria = categorias.map { |m| m["nombre"] }
        imagenes_categoria = categorias.map { |m| m["imagen"] }

        expect(nombres_categoria).to match_array(["Bebidas", "Lacteos" ])
        expect(imagenes_categoria).to match_array(["imagen_bebidas.jpg", "imagen_lacteos.jpg"])
      end
    end

  end

  # create
  describe "POST /productos/:producto_id/categorias" do

    before :each do
      @parametros_categoria = {
        "categoria_id": @bebidas.id
      }.to_json
      expect(@jugo.categorias).not_to include(@bebidas)
    end

    context "Usuario no autenticado" do
      it "No permite la petición y devuelve un mensaje de error" do
        post "/productos/#{@jugo.id}/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario no administrador autenticado" do
      it "No le permite la petición al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/productos/#{@jugo.id}/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario administrador autenticado" do
      it "agrega una categoría al producto con id :producto_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/productos/#{@jugo.id}/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@jugo.reload.categorias).to include(@bebidas)
      end
    end
  end

  # destroy
  describe "DELETE /productos/:producto_id/categorias/:id" do

    before :each do
      @jugo.categorias.clear
      @jugo.categorias << @bebidas
      expect(@jugo.reload.categorias).to include(@bebidas)
    end

    context "Usuario no autenticado"do
      it "No permite la petición y devuelve un mensaje de error" do
        delete "/productos/#{@jugo.id}/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario no administrador autenticado" do
      it "No le permite la petición al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/productos/#{@jugo.id}/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario administrador autenticado" do
      it "quita la categoría identificada con :id del producto con id :producto_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/productos/#{@jugo.id}/categorias/#{@bebidas.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@jugo.reload.categorias.empty?).to be true
        expect(Categoria.exists?(@bebidas.id)).to be true
      end
    end
  end

end
