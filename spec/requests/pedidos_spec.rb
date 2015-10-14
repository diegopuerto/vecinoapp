require 'rails_helper'

RSpec.describe "Pedidos", type: :request do
  before :each do
    	@cabeceras_peticion = {
      		"Accept": "application/json",
      		"Content-Type": "application/json"
    	}
    	@usuario_uno = FactoryGirl.create :usuario_uno
    	@admin = FactoryGirl.create :admin
   		@tienda = FactoryGirl.create :tienda
    	@pedido_uno = FactoryGirl.create :pedido_uno
    	@pedido_dos = FactoryGirl.create :pedido_dos
  end

    # index
  	describe "GET /negocios/:negocio_id/pedidos" do

  		before :each do
      		@tienda.pedidos << [@pedido_uno, @pedido_dos]
    	end

  		context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

          		get "/negocios/#{@tienda.id}/pedidos", {}, @cabeceras_peticion

          		expect(response.status).to eq 401 # Unauthorized
          		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado" do
      		it "No le permite la consulta al usuario y devuelve un mensaje de error" do

          		@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

          		get "/negocios/#{@tienda.id}/pedidos", {}, @cabeceras_peticion

          		expect(response.status).to eq 401 # Unauthorized
          		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario administrador autenticado" do

    		it "Devuelve todos los pedidos del negocio con id :negocio_id" do

      			@cabeceras_peticion.merge! @admin.create_new_auth_token

      			get "/negocios/#{@tienda.id}/pedidos", {}, @cabeceras_peticion

      			expect(response.status).to eq 200 # OK

      			body = JSON.parse(response.body)
      			pedidos = body['pedidos']

      			propinas_pedido = pedidos.map { |m| m["propina"]}
      			comentarios_pedido = pedidos.map { |m| m["comentario"]}
      			totales_pedido = pedidos.map { |m| m["total"]}
      			estados_pedido = pedidos.map { |m| m["estado"]}
      			medios_pagos_pedido = pedidos.map { |m| m["medio_pago"]}

      			expect(propinas_pedido).to match_array([@pedido_uno.propina, @pedido_dos.propina])
      			expect(comentarios_pedido).to match_array([@pedido_uno.comentario, @pedido_dos.comentario])
      			expect(totales_pedido).to match_array([@pedido_uno.total, @pedido_dos.total])
      			expect(estados_pedido).to match_array([@pedido_uno.estado, @pedido_dos.estado])
      			expect(medios_pagos_pedido).to match_array([@pedido_uno.medio_pago, @pedido_dos.medio_pago])
    		end
  		end
  	end

  	# show
	describe "SHOW /negocios/:negocio_id/pedidos/:id" do

		before :each do
      		@tienda.pedidos << @pedido_uno
    	end

    	context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		get "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado" do
      		it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        		get "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario administrador autenticado" do
      		it "Devuelve la informacion del producto con id :id" do
        		# Login admin
        		@cabeceras_peticion.merge! @admin.create_new_auth_token

        		get "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 200 #OK

        		body = JSON.parse(response.body)
        		pedido = body['pedido']

        		expect(pedido["propina"]).to eq @pedido_uno.propina
        		expect(pedido["comentario"]).to eq @pedido_uno.comentario
        		expect(pedido["total"]).to eq @pedido_uno.total
        		expect(pedido["estado"]).to eq @pedido_uno.estado
        		expect(pedido["medio_pago"]).to eq @pedido_uno.medio_pago
      		end
    	end
	end

	#update
  	describe "PUT /negocios/:negocio_id/pedidos/:id" do

    	before :each do
        	@parametros_pedido = {
        	"estado": "cancelado",
        	}.to_json

        	@tienda.pedidos << @pedido_uno
        	expect(@tienda.reload.pedidos).to include(@pedido_uno)
    	end


    	context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		put "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado" do
      		it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        		put "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario administrador autenticado" do
        	it "Actualiza el pedido identificado con :id del negocio con id :negocio_id" do
          		# Login usuario_admin
          		@cabeceras_peticion.merge! @admin.create_new_auth_token

          		put "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

          		expect(response.status).to be 204 # No Content
          		expect(@tienda.reload.pedidos.find(@pedido_uno.id).estado).to eq "cancelado"
        	end
    	end
  	end
end
