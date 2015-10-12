require 'rails_helper'

RSpec.describe PropietarioNegocio, type: :model do

	describe "Atributos" do

		it "es válido con todos sus datos" do
	  	@propietario_negocio = FactoryGirl.build(:propietario_negocio)
			@propietario_negocio.usuario = FactoryGirl.build(:usuario_uno)
			@propietario_negocio.negocio = FactoryGirl.build(:tienda)
			expect(@propietario_negocio).to be_valid
	  end

		it "es inválido si falta algún dato" do
	  	@propietario_negocio = FactoryGirl.build(:propietario_negocio)
			@propietario_negocio.valid?
			expect(@propietario_negocio.errors[:usuario]).to include(I18n.t 'errors.messages.blank')
			expect(@propietario_negocio.errors[:negocio]).to include(I18n.t 'errors.messages.blank')
	  end

	  it "es inválido si el par negocio-usuario no es único" do
	  	@usuario = FactoryGirl.build(:usuario_uno)
	  	@negocio = FactoryGirl.build(:tienda)
	  	@propietario_negocio = FactoryGirl.create(:propietario_negocio,
	  		usuario: @usuario,
	  		negocio: @negocio)
	  	@propietario_negocio_no_valido = FactoryGirl.build(:propietario_negocio,
	  		usuario: @usuario,
	  		negocio: @negocio)
	  	expect(@propietario_negocio_no_valido).to be_invalid
	  	expect(@propietario_negocio_no_valido.errors[:usuario]).to include(I18n.t 'errors.messages.taken')
	  end

	  it "es inválido si el negocio o el usuario no existen" do
      Usuario.destroy_all
	  	@propietario_negocio = FactoryGirl.build(:propietario_negocio)
	  	expect(Usuario.exists?(1)).to be false
	  	expect(Negocio.exists?(1)).to be false
	  	@propietario_negocio.usuario_id = 1
	  	@propietario_negocio.negocio_id = 1
	  	expect(@propietario_negocio).to be_invalid
	  	expect(@propietario_negocio.errors[:usuario]).to include(I18n.t 'errors.messages.blank')
	  	expect(@propietario_negocio.errors[:negocio]).to include(I18n.t 'errors.messages.blank')
	  end
	end

  describe "Comportamiento" do

  	before :each do
  		@propietario_uno = FactoryGirl.create(:usuario_uno)
  		@propietario_dos = FactoryGirl.create(:usuario_dos)
  	end

		it "actualiza atributo es_propietario del usuario cuando se agrega como propietario" do
			@tienda = FactoryGirl.create(:tienda)
			expect(@propietario_dos.es_propietario?).to be false
  		expect(@propietario_dos.negocios_propios.empty?).to be true
  		@tienda.propietarios << @propietario_dos
  		expect(@propietario_dos.es_propietario?).to be true
  		expect(@propietario_dos.negocios_propios.empty?).to be false
		end

		# revisar!!!!
		it "actualiza atributo es_propietario del propietario cuando se quita un propietario" do
			@tienda = FactoryGirl.create(:tienda, propietarios: [@propietario_uno])
			expect(@propietario_uno.es_propietario?).to be true
  		expect(@propietario_uno.negocios_propios.empty?).to be false
  		@tienda.propietarios.destroy(@propietario_uno)
  		expect(@propietario_uno.reload.es_propietario?).to be false
  		expect(@propietario_uno.reload.negocios_propios.empty?).to be true
		end

		# Si se eliminan los propietarios con clear no se disparan los callbacks
		it "desactiva negocio si se eliminan todos sus propietarios" do
  		@tienda = FactoryGirl.create :tienda,
  			activo: true,
  			propietarios: [@propietario_uno, @propietario_dos]
  		@tienda.propietarios.destroy(@propietario_uno)
  		expect(@tienda.activo).to be true
  		@tienda.propietarios.destroy(@propietario_dos)
  		expect(@tienda.activo).to be false
  	end

  end

end
