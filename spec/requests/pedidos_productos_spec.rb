require 'rails_helper'

RSpec.describe "PedidosProductos", type: :request do
  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @admin = FactoryGirl.create :admin
    @producto_uno = FactoryGirl.create :jugo
    @producto_dos = FactoryGirl.create :leche
    @negocio_uno = FactoryGirl.create :tienda
    @pedido_uno = FactoryGirl.create :pedido_uno
    @negocio_uno.productos << @producto_uno
    @negocio_uno.productos << @producto_dos
    @pn = NegocioProducto.find_by negocio_id: @negocio_uno.id, producto_id: @producto_uno.id
    @pn_dos = NegocioProducto.find_by negocio_id: @negocio_uno.id, producto_id: @producto_dos.id
    @pn.precio = 15000
    @pn.save
    @pn_dos.precio = 30000
    @pn_dos.save
    @negocio_uno.pedidos << @pedido_uno
    @pedido_dos = FactoryGirl.create :pedido_dos
    expect(@negocio_uno.productos).to include(@producto_uno)
  end

  # index
  describe "GET /pedidos/:pedido_id/productos" do

    before :each do
      @pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_uno, :cantidad => 5, :precio => @producto_uno.precio)
      @pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_dos, :cantidad => 10, :precio => @producto_dos.precio)
      @pedido_dos.save && @pedido_dos.pedidos_productos.create(:producto => @producto_dos, :cantidad => 10, :precio => @producto_dos.precio)
    end

    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do
        get "/pedidos/#{@pedido_uno.id}/productos", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/pedidos/#{@pedido_uno.id}/productos", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
      it "devuelve todos los productos del pedido con id :pedido_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/pedidos/#{@pedido_uno.id}/productos", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        productos = body['productos']

        nombres_producto = productos.map { |m| m["nombre"] }
        diferenciadores_producto = productos.map { |m| m["diferenciador"] }
        marcas_producto = productos.map { |m| m["marca"] }
        presentaciones_producto = productos.map { |m| m["presentacion"]}
        precios_producto = productos.map { |m| m["precio"]}
        imagenes_producto =  productos.map {|m| m["imagen"]}


        expect(nombres_producto).to match_array([@producto_uno.nombre, @producto_dos.nombre ])
        expect(diferenciadores_producto).to match_array([@producto_uno.diferenciador, @producto_dos.diferenciador ])
        expect(marcas_producto).to match_array([@producto_uno.marca, @producto_dos.marca ])
        expect(presentaciones_producto).to match_array([@producto_uno.presentacion, @producto_dos.presentacion ])
        expect(precios_producto).to match_array([@pn.precio, @pn_dos.precio ])
        expect(imagenes_producto).to match_array([@producto_uno.imagen, @producto_dos.imagen ])
       
      end
    end
  end


   # create
  describe "POST /pedidos/:pedido_id/productos" do

    before :each do
      @parametros_producto = {
      	"cantidad": 5,
       #"precio": @producto_uno.precio,
        "producto_id": @producto_uno.id
      }.to_json
      expect(@pedido_uno.productos).not_to include(@producto_uno)
    end

    context "Usuario no autenticado" do
      it "No permite la petición y devuelve un mensaje de error" do
        post "/pedidos/#{@pedido_uno.id}/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario no administrador autenticado" do
      it "No le permite la petición al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        post "/pedidos/#{@pedido_uno.id}/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario administrador autenticado" do
      it "agrega un producto al pedido con id :pedido_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/pedidos/#{@pedido_uno.id}/productos", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@pedido_uno.reload.productos).to include(@producto_uno)
      end
    end
  end

  # destroy
  describe "DELETE /pedidos/:pedido_id/productos/:id" do

    before :each do
      @pedido_uno.productos.clear
      @pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_uno, :cantidad => 5, :precio => @producto_uno.precio)
      expect(@pedido_uno.reload.productos).to include(@producto_uno)
    end

    context "Usuario no autenticado"do
      it "No permite la petición y devuelve un mensaje de error" do
        delete "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario no administrador autenticado" do
      it "No le permite la petición al usuario y devuelve un mensaje de error" do
        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        delete "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "Usuario administrador autenticado" do
      it "quita el producto identificado con :id del pedido con id :pedido_id" do
        # Login admin
        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@pedido_uno.reload.productos.empty?).to be true
        expect(Producto.exists?(@producto_uno.id)).to be true
      end
    end
  end

  # update
  describe "PUT /pedidos/:pedido_id/productos/:id" do

    before :each do
        @parametros_producto = {
        "cantidad": 21
        }.to_json

        @pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_uno, :cantidad => 5, :precio => @producto_uno.precio)
        expect(@pedido_uno.reload.productos).to include(@producto_uno)
    end


    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        put "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        put "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", @parametros_producto, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
        it "Actualiza el producto identificado con :id del negocio con id :negocio_id" do
          # Login usuario_admin
          @cabeceras_peticion.merge! @admin.create_new_auth_token

          put "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", @parametros_producto, @cabeceras_peticion

          expect(response.status).to be 204 # No Content
          #expect(@pedido_uno.reload.productos.find(@producto_uno.id).cantidad).to eq 21

          pp = PedidoProducto.find_by pedido_id: @pedido_uno.id, producto_id: @producto_uno.id
          expect(PedidoProducto.find(pp.id).cantidad).to eq 21

        end
    end
  end

  # show
  describe "GET /pedidos/:pedido_id/productos/:id" do

    before :each do
        @pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_uno, :cantidad => 5, :precio => @producto_uno.precio)
        expect(@pedido_uno.reload.productos).to include(@producto_uno)
    end


    context "usuario no autenticado" do
      it "No permite la consulta y devuelve un mensaje de error" do

        get "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario no administrador autenticado" do
      it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        # Login usuario_uno
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to eq 401 # Unauthorized
        expect(response.body).to include("Acceso restringido. Solo Administradores")
      end
    end

    context "usuario administrador autenticado" do
        it "Actualiza el producto identificado con :id del negocio con id :negocio_id" do
          # Login usuario_admin
          @cabeceras_peticion.merge! @admin.create_new_auth_token

          get "/pedidos/#{@pedido_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

          expect(response.status).to be 200 #OK

          body = JSON.parse(response.body)
          producto = body['producto']

          expect(producto["nombre"]).to eq @producto_uno.nombre
          expect(producto["diferenciador"]).to eq @producto_uno.diferenciador
          expect(producto["marca"]).to eq @producto_uno.marca
          expect(producto["presentacion"]).to eq @producto_uno.presentacion
          expect(producto["precio"]).to eq @producto_uno.precio
          expect(producto["imagen"]).to eq @producto_uno.imagen
        end
    end
  end

end
