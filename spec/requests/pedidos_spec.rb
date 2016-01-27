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

    # index negocio_pedido
  	describe "GET /negocios/:negocio_id/pedidos" do

  		before :each do
          @usuario_dos = FactoryGirl.create :usuario_dos
          @usuario_uno.negocios_propios << @tienda
          expect(@usuario_uno.negocios_propios).to include @tienda
      		@tienda.pedidos << [@pedido_uno, @pedido_dos]
    	end

  		context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

          		get "/negocios/#{@tienda.id}/pedidos", {}, @cabeceras_peticion

          		expect(response.status).to eq 401 # Unauthorized
          		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado no dueño de los pedidos" do
      		it "No permite la consulta y devuelve un mensaje de error" do

          		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

          		get "/negocios/#{@tienda.id}/pedidos", {}, @cabeceras_peticion

          		expect(response.status).to eq 401 # Unauthorized
          		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "usuario no administrador autenticado dueño de los pedidos" do
          it "Devuelve todos los pedidos del negocio con id :negocio_id" do

              @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

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

  # show negocio_pedido
	describe "SHOW /negocios/:negocio_id/pedidos/:id" do

		before :each do
          @usuario_uno.negocios_propios << @tienda
          expect(@usuario_uno.negocios_propios).to include @tienda
      		@tienda.pedidos << @pedido_uno
          expect(@tienda.reload.pedidos).to include(@pedido_uno)
          @usuario_dos = FactoryGirl.create :usuario_dos
    	end

    	context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		get "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado no dueño del pedido" do
      		it "No permite la consulta y devuelve un mensaje de error" do
        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		get "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "usuario no administrador autenticado dueño del pedido" do
          it "Devuelve la informacion del pedido con id :id" do
            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

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

    	context "usuario administrador autenticado" do
      		it "Devuelve la informacion del pedido con id :id" do
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

	#update negocio_pedido
  	describe "PUT /negocios/:negocio_id/pedidos/:id" do

    	before :each do
        	@parametros_pedido = {
        	"estado": "cancelado",
        	}.to_json

          @usuario_uno.negocios_propios << @tienda
        	@tienda.pedidos << @pedido_uno
        	expect(@tienda.reload.pedidos).to include(@pedido_uno)
          @usuario_dos = FactoryGirl.create :usuario_dos
    	end


    	context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		put "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado no dueño del pedido" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		put "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "usuario no administrador autenticado dueño del pedido" do
          it "Actualiza el pedido identificado con :id del negocio con id :negocio_id" do

            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

            put "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

            expect(response.status).to be 204 # No Content
            expect(@tienda.reload.pedidos.find(@pedido_uno.id).estado).to eq "cancelado"
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

  	# destroy negocios_pedidos
  	describe "DELETE /negocios/:negocio_id/pedidos/:id" do

    	before :each do
      		@tienda.pedidos.clear
          @usuario_uno.negocios_propios << @tienda
          expect(@usuario_uno.reload.negocios_propios).to include(@tienda)
      		@tienda.pedidos << @pedido_uno
      		expect(@tienda.reload.pedidos).to include(@pedido_uno)
          @usuario_dos = FactoryGirl.create :usuario_dos
    	end

    	context "Usuario no autenticado"do
      		it "No permite la petición y devuelve un mensaje de error" do

        		delete "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "Usuario no administrador autenticado no dueño del pedido" do
      		it "No permite la petición y devuelve un mensaje de error" do
        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		delete "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "Usuario no administrador autenticado dueño del pedido" do
          it "No permite la petición y devuelve un mensaje de error" do
            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

            delete "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

            expect(response.status).to eq 401 # Unauthorized
            expect(response.body).to include("Acceso restringido. Solo Administradores")
          end
      end

    	context "Usuario administrador autenticado" do
      		it "quita el pedido identificado con :id del producto con id :usuario_id" do
        		# Login admin
        		@cabeceras_peticion.merge! @admin.create_new_auth_token

        		delete "/negocios/#{@tienda.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to be 204 # No Content
        		expect(@usuario_uno.reload.pedidos.empty?).to be true
      		end
    	end
  	end

  	# index usuario_pedido
  	describe "GET /usuarios/:usuario_id/pedidos" do

  		before :each do
      		@usuario_uno.pedidos << [@pedido_uno, @pedido_dos]
          expect(@usuario_uno.pedidos.count).to eq 2
          @usuario_dos = FactoryGirl.create :usuario_dos
          @pedido_tres = FactoryGirl.create(:pedido_dos, propina: 10000)
          @usuario_dos.pedidos << @pedido_tres
          expect(@usuario_dos.pedidos).to include @pedido_tres
    	end

  		context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

          		get "/usuarios/#{@usuario_uno.id}/pedidos", {}, @cabeceras_peticion

          		expect(response.status).to eq 401 # Unauthorized
          		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "usuario no administrador autenticado no dueño de los pedidos" do
          it "No permite la consulta y devuelve un mensaje de error" do

              @cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

              get "/usuarios/#{@usuario_uno.id}/pedidos", {}, @cabeceras_peticion

              expect(response.status).to eq 401 # Unauthorized
              expect(response.body).to include("Acceso restringido. Solo Administradores")
          end
      end

    	context "usuario no administrador autenticado dueño de los pedidos" do
      		it "le permite la consulta al usuario" do

          		@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

          		get "/usuarios/#{@usuario_uno.id}/pedidos", {}, @cabeceras_peticion

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

    	context "usuario administrador autenticado" do

    		it "Devuelve todos los pedidos del usuario con id :usuario_id" do

      			@cabeceras_peticion.merge! @admin.create_new_auth_token

      			get "/usuarios/#{@usuario_uno.id}/pedidos", {}, @cabeceras_peticion

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

  	# show usuario_pedido
	describe "SHOW /usuarios/:usuario_id/pedidos/:id" do

		before :each do
      		@usuario_uno.pedidos << @pedido_uno
          @tienda.pedidos << @pedido_uno
          @usuario_dos = FactoryGirl.create :usuario_dos
    	end

    	context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		get "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado no dueño del pedido" do
      		it "No le permite la consulta al usuario y devuelve un mensaje de error" do
        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		get "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "usuario no administrador autenticado dueño del pedido" do
          it "le permite la consulta al usuario y devuelve un mensaje de error" do
            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

            get "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

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

    	context "usuario administrador autenticado" do
      		it "Devuelve la informacion del pedido con id :id" do
        		# Login admin
        		@cabeceras_peticion.merge! @admin.create_new_auth_token

        		get "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

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

	#update usuario_pedido
  	describe "PUT /usuarios/:usuario_id/pedidos/:id" do

    	before :each do
        	@parametros_pedido = {
        	"estado": "cancelado",
        	}.to_json

        	@usuario_uno.pedidos << @pedido_uno
          @tienda.pedidos << @pedido_uno
        	expect(@usuario_uno.reload.pedidos).to include(@pedido_uno)
          @usuario_dos = FactoryGirl.create :usuario_dos
    	end


    	context "usuario no autenticado" do
      		it "No permite la consulta y devuelve un mensaje de error" do

        		put "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "usuario no administrador autenticado no dueño del pedido" do
      		it "No le permite la consulta al usuario y devuelve un mensaje de error" do

        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		put "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "usuario no administrador autenticado dueño del pedido" do
          it "le permite la consulta al usuario y devuelve un mensaje de error" do

            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

            put "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

            expect(response.status).to be 204 # No Content
            expect(@usuario_uno.reload.pedidos.find(@pedido_uno.id).estado).to eq "cancelado"
          end
      end

    	context "usuario administrador autenticado" do
        	it "Actualiza el pedido identificado con :id del usuario con id :usuario_id" do
          		# Login usuario_admin
          		@cabeceras_peticion.merge! @admin.create_new_auth_token

          		put "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

          		expect(response.status).to be 204 # No Content
          		expect(@usuario_uno.reload.pedidos.find(@pedido_uno.id).estado).to eq "cancelado"
        	end
    	end
  	end

    # create usuarios_pedidos
    describe "POST /usuarios/:usuario_id/pedidos/" do
      before :each do

          @usuario_dos = FactoryGirl.create :usuario_dos
          @producto = FactoryGirl.create :producto
          @tienda.productos << @producto
          expect(@tienda.productos).to include @producto
          @direccion = FactoryGirl.create(:direccion_casa, usuario_id: @usuario_uno.id)
          @usuario_uno.direcciones << @direccion
          expect(@usuario_uno.direcciones).to include @direccion

          @parametros_pedido = {
          propina: @pedido_uno.propina,
          comentario: @pedido_uno.comentario,
          total: @pedido_uno.total,
          estado: @pedido_uno.estado,
          medio_pago: @pedido_uno.medio_pago,
          negocio_id: @tienda.id,
          direccion_id: @direccion.id,
          pedidos_productos_attributes: [{cantidad: 5, producto_id: @producto.id, precio: 1550}]
          }.to_json
 

      end

      context "Usuario no autenticado"do
          it "No permite la petición y devuelve un mensaje de error" do

            post "/usuarios/#{@usuario_uno.id}/pedidos/", @parametros_pedido, @cabeceras_peticion

            expect(response.status).to eq 401 # Unauthorized
            expect(response.body).to include("Acceso restringido. Solo Administradores")
          end
      end

      context "Usuario no administrador autenticado no dueño" do
          it "No le permite la petición al usuario y devuelve un mensaje de error" do
            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

            post "/usuarios/#{@usuario_uno.id}/pedidos/", @parametros_pedido, @cabeceras_peticion

            expect(response.status).to eq 401 # Unauthorized
            expect(response.body).to include("Acceso restringido. Solo Administradores")
          end
      end

       context "Usuario no administrador autenticado dueño" do
          it "le permite la petición al usuario y devuelve un mensaje de error" do
            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

            post "/usuarios/#{@usuario_uno.id}/pedidos/", @parametros_pedido, @cabeceras_peticion

            expect(response.status).to be 204 # No Content
            expect(@usuario_uno.reload.pedidos.empty?).to be false
            expect(@usuario_uno.pedidos.first.propina).to eq @pedido_uno.propina
            expect(@usuario_uno.pedidos.first.comentario).to eq @pedido_uno.comentario
            expect(@usuario_uno.pedidos.first.total).to eq @pedido_uno.total
            expect(@usuario_uno.pedidos.first.estado).to eq @pedido_uno.estado
            expect(@usuario_uno.pedidos.first.medio_pago).to eq @pedido_uno.medio_pago
            expect(@usuario_uno.pedidos.first.negocio_id).to eq @tienda.id
            expect(@usuario_uno.pedidos.first.direccion_id).to eq @direccion.id

          end
      end


      context "Usuario administrador autenticado" do
          it "Usuario administrador crea pedido" do
            # Login admin
            @cabeceras_peticion.merge! @admin.create_new_auth_token

            post "/usuarios/#{@usuario_uno.id}/pedidos/", @parametros_pedido, @cabeceras_peticion

            expect(response.status).to be 204 # No Content
            expect(@usuario_uno.reload.pedidos.empty?).to be false
            expect(@usuario_uno.pedidos.first.propina).to eq @pedido_uno.propina
            expect(@usuario_uno.pedidos.first.comentario).to eq @pedido_uno.comentario
            expect(@usuario_uno.pedidos.first.total).to eq @pedido_uno.total
            expect(@usuario_uno.pedidos.first.estado).to eq @pedido_uno.estado
            expect(@usuario_uno.pedidos.first.medio_pago).to eq @pedido_uno.medio_pago
            expect(@usuario_uno.pedidos.first.negocio_id).to eq @tienda.id
            expect(@usuario_uno.pedidos.first.direccion_id).to eq @direccion.id

          end
      end
    end


  	# destroy usuarios_pedidos
  	describe "DELETE /usuarios/:usuario_id/pedidos/:id" do

    	before :each do
      		@usuario_uno.pedidos.clear
      		@usuario_uno.pedidos << @pedido_uno
      		expect(@usuario_uno.reload.pedidos).to include(@pedido_uno)
          @usuario_dos = FactoryGirl.create :usuario_dos
    	end

    	context "Usuario no autenticado"do
      		it "No permite la petición y devuelve un mensaje de error" do

        		delete "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

    	context "Usuario no administrador autenticado no dueño" do
      		it "No le permite la petición al usuario y devuelve un mensaje de error" do
        		# Login usuario_uno
        		@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		delete "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to eq 401 # Unauthorized
        		expect(response.body).to include("Acceso restringido. Solo Administradores")
      		end
    	end

      context "Usuario no administrador autenticado dueño" do
          it "no le permite la petición al usuario y devuelve un mensaje de error" do
            # Login usuario_uno
            @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

            delete "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

            expect(response.status).to be 401 # No Content
            expect(response.body).to include("Acceso restringido. Solo Administradores")
          end
      end

    	context "Usuario administrador autenticado" do
      		it "quita el pedido identificado con :id del producto con id :usuario_id" do
        		# Login admin
        		@cabeceras_peticion.merge! @admin.create_new_auth_token

        		delete "/usuarios/#{@usuario_uno.id}/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

        		expect(response.status).to be 204 # No Content
        		expect(@usuario_uno.reload.pedidos.empty?).to be true
      		end
    	end
  	end

end
