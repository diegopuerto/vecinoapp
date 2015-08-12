describe "Usuarios API" do

  # index
  describe "GET /usuarios" do
    it "Devuelve todos los usuarios" do
      FactoryGirl.create :usuario_uno
      FactoryGirl.create :usuario_dos

      get "/usuarios", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200 # OK

      body = JSON.parse(response.body)
      usuarios = body['usuarios']
      correos_usuario = usuarios.map { |m| m["email"] }
      nombres_usuario = usuarios.map { |m| m["name"] }
      imagenes_usuario = usuarios.map { |m| m["image"] }
      telefonos_usuario = usuarios.map { |m| m["telefono"] }
      admins_usuario = usuarios.map { |m| m["es_admin"] }
      propietarios_usuario = usuarios.map { |m| m["es_propietario"] }

      expect(correos_usuario).to match_array(["usuario1@correo.com", "usuario2@correo.com"])
      expect(nombres_usuario).to match_array(["Usuario Uno", "Usuario Dos"])
      expect(imagenes_usuario).to match_array(["usuario1.png", "usuario2.png"])
      expect(telefonos_usuario).to match_array(["3004560987", "3006785432"])
      expect(admins_usuario).to match_array([false, false])
      expect(propietarios_usuario).to match_array([false, false])
    end
  end
 
  # show
  describe "GET /usuarios/:id" do
    it "Devuelve el usuarios solicitado" do
      u = FactoryGirl.create :usuario_uno

      get "/usuarios/#{u.id}", {}, { "Accept" => "application/json" }
      expect(response.status).to be 200 # OK

      body = JSON.parse(response.body)
      usuario = body['usuario']
      expect(usuario["email"]).to eq "usuario1@correo.com"
      expect(usuario["name"]).to eq "Usuario Uno"
      expect(usuario["image"]).to eq "usuario1.png"
      expect(usuario["telefono"]).to eq "3004560987"
      expect(usuario["es_admin"]).to eq false
      expect(usuario["es_propietario"]).to eq false
    end
  end

end