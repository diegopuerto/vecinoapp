require 'rails_helper'

RSpec.describe Negocio, type: :model do

  it "es válido con todos sus datos" do
		@tienda = FactoryGirl.build(:tienda)
		expect(@tienda).to be_valid
  end

  describe "Atributos requeridos" do

    it "es inválido sin nombre" do
      @tienda = FactoryGirl.build(:tienda, nombre: nil)
	  	@tienda.valid?
	  	expect(@tienda.errors[:nombre]).to include("can't be blank")
		end

		it "es inválido sin dirección" do
		  @tienda = FactoryGirl.build(:tienda, direccion: nil)
		  @tienda.valid?
		  expect(@tienda.errors[:direccion]).to include("can't be blank")
		end

		it "es inválido sin latitud" do
		  @tienda = FactoryGirl.build(:tienda, latitud: nil)
		  @tienda.valid?
		  expect(@tienda.errors[:latitud]).to include("can't be blank")
		end

		it "es inválido sin longitud" do
		  @tienda = FactoryGirl.build(:tienda, longitud: nil)
		  @tienda.valid?
		  expect(@tienda.errors[:longitud]).to include("can't be blank")
		end

		it "es inválido sin tiempo de entrega" do
		  @tienda = FactoryGirl.build(:tienda, tiempo_entrega: nil)
		  @tienda.valid?
		  expect(@tienda.errors[:tiempo_entrega]).to include("can't be blank")
	  end

	  it "es inválido sin cobertura" do
	  	@tienda = FactoryGirl.build(:tienda, cobertura: nil)
	  	@tienda.valid?
	  	expect(@tienda.errors[:cobertura]).to include("can't be blank")
	  end

	  it "es inválido sin telefono" do
	  	@tienda = FactoryGirl.build(:tienda, telefono: nil)
	  	@tienda.valid?
	  	expect(@tienda.errors[:telefono]).to include("can't be blank")
	  end

	  it "es inválido sin hora de apertura" do
	  	@tienda = FactoryGirl.build(:tienda, hora_apertura: nil)
	  	@tienda.valid?
	  	expect(@tienda.errors[:hora_apertura]).to include("can't be blank")
	  end

	  it "es inválido sin hora de cierre" do
	  	@tienda = FactoryGirl.build(:tienda, hora_cierre: nil)
	  	@tienda.valid?
	  	expect(@tienda.errors[:hora_cierre]).to include("can't be blank")
	  end

#	  it "es inválido sin propietarios" do
#	  	@tienda = FactoryGirl.build(:tienda)
#	  	expect(@tienda.propietarios.empty?).to be true
#	  	@tienda.valid?
#	  	expect(@tienda.errors[:propietarios]).to include("can't be blank")
#	  end

  end

  describe "Valores de atributos" do

  	it "es inválido si el nombre tiene más de 50 caracteres" do
  		@tienda = FactoryGirl.build(:tienda, nombre: "a"*51)
	  	@tienda.valid?
	  	expect(@tienda.errors[:nombre]).to include("is too long (maximum is 50 characters)")
  	end

  	it "es inválido si la dirección tiene más de 255 caracteres" do
  		@tienda = FactoryGirl.build(:tienda, direccion: "a"*256)
	  	@tienda.valid?
	  	expect(@tienda.errors[:direccion]).to include("is too long (maximum is 255 characters)")
	  end

  	it "es inválido si la latitud no está entre -90 y 90" do
  		@tienda = FactoryGirl.build(:tienda, latitud: -99)
	  	@tienda.valid?
	  	expect(@tienda.errors[:latitud]).to include("must be greater than or equal to -90")
	  	@tienda.latitud = 94
	  	@tienda.valid?
	  	expect(@tienda.errors[:latitud]).to include("must be less than or equal to 90")
  	end

  	it "es inválido si la longitud no está entre -180 y 180" do
  		@tienda = FactoryGirl.build(:tienda, longitud: -189)
	  	@tienda.valid?
	  	expect(@tienda.errors[:longitud]).to include("must be greater than or equal to -180")
	  	@tienda.longitud = 189
	  	@tienda.valid?
	  	expect(@tienda.errors[:longitud]).to include("must be less than or equal to 180")
	  end

  	it "es inválido si la reputación es menor que cero" do
  		@tienda = FactoryGirl.build(:tienda, reputacion: -2)
	  	@tienda.valid?
	  	expect(@tienda.errors[:reputacion]).to include("must be greater than or equal to 0")
	  end

  	it "es inválido si la reputación no es entero" do
  		@tienda = FactoryGirl.build(:tienda, reputacion: 2.5)
	  	@tienda.valid?
	  	expect(@tienda.errors[:reputacion]).to include("must be an integer")
	  end

  	it "es inválido si el tiempo de entrega no es 15, 30, 45, 60, 75, 90, 105 o 120" do
  		@tienda = FactoryGirl.build(:tienda, tiempo_entrega: 17)
	  	@tienda.valid?
	  	expect(@tienda.errors[:tiempo_entrega]).to include("is not included in the list")
  	end

  	it "es inválido si el pedido mínimo es menor que cero" do
  		@tienda = FactoryGirl.build(:tienda, pedido_minimo: -2)
	  	@tienda.valid?
	  	expect(@tienda.errors[:pedido_minimo]).to include("must be greater than or equal to 0")
	  end

  	it "es inválido si el pedido mínimo no es entero" do
  		@tienda = FactoryGirl.build(:tienda, pedido_minimo: 2.5)
	  	@tienda.valid?
	  	expect(@tienda.errors[:pedido_minimo]).to include("must be an integer")
  	end

  	it "es inválido si el recargo es menor que cero" do
  		@tienda = FactoryGirl.build(:tienda, recargo: -2)
	  	@tienda.valid?
	  	expect(@tienda.errors[:recargo]).to include("must be greater than or equal to 0")
	  end

  	it "es inválido si el recargo no es entero" do
  		@tienda = FactoryGirl.build(:tienda, recargo: 2.5)
	  	@tienda.valid?
	  	expect(@tienda.errors[:recargo]).to include("must be an integer")
	  end

  	it "es inválido si la cobertura es menor que cero" do
  		@tienda = FactoryGirl.build(:tienda, cobertura: -2)
	  	@tienda.valid?
	  	expect(@tienda.errors[:cobertura]).to include("must be greater than or equal to 0")
	  end

  	it "es inválido si la cobertura no es un entero" do
  		@tienda = FactoryGirl.build(:tienda, cobertura: 2.5)
	  	@tienda.valid?
	  	expect(@tienda.errors[:cobertura]).to include("must be an integer")
	  end

  	it "es inválido si la hora de cierre es antes de que la hora de apertura" do
  		@tienda = FactoryGirl.build(:tienda, hora_apertura: Time.now, hora_cierre: Time.now - 3.hours)
	  	@tienda.valid?
	  	expect(@tienda.errors[:hora_cierre]).to include("Debe cerrar después de abrir")
	  	expect(@tienda.errors[:hora_apertura]).to include("Debe cerrar después de abrir")
  	end
  end

=begin
  describe "Comportamiento" do

  	before :each do
  		@propietario_uno = FactoryGirl.create(:usuario_uno)
  		@propietario_dos = FactoryGirl.create(:usuario_dos)
  	end

  	it "actualiza atributo es_propietario del propietario cuando se crea el negocio" do
  		expect(@propietario_uno.es_propietario?).to be false
  		expect(@propietario_uno.negocios_propios.empty?).to be true
  		@tienda = FactoryGirl.create(:tienda, propietarios: [@propietario_uno])
  		expect(@propietario_uno.es_propietario?).to be true
  		expect(@propietario_uno.negocios_propios.empty?).to be false
  	end

		it "actualiza atributo es_propietario del propietario cuando se agrega un propietario" do
			@tienda = FactoryGirl.create(:tienda, propietarios: [@propietario_uno])
			expect(@propietario_dos.es_propietario?).to be false
  		expect(@propietario_dos.negocios_propios.empty?).to be true
  		@tienda.propietarios << @propietario_dos
  		expect(@propietario_dos.es_propietario?).to be true
  		expect(@propietario_dos.negocios_propios.empty?).to be false
		end

		it "actualiza atributo es_propietario del propietario cuando se quita un propietario" do
			@tienda = FactoryGirl.create(:tienda, propietarios: [@propietario_uno])
			expect(@propietario_uno.es_propietario?).to be true
  		expect(@propietario_uno.negocios_propios.empty?).to be false
  		@tienda.propietarios.destroy(@propietario_uno)
  		expect(@propietario_uno.es_propietario?).to be false
  		expect(@propietario_uno.negocios_propios.empty?).to be true
		end

  	it "actualiza atributo es_propietario del/los propietario/s cuando se elimina el negocio" do
  		expect(@propietario_uno.es_propietario?).to be false
  		expect(@propietario_uno.negocios_propios.empty?).to be true
  		expect(@propietario_dos.es_propietario?).to be false
  		expect(@propietario_dos.negocios_propios.empty?).to be true
  		@tienda = FactoryGirl.create(:tienda, propietarios: [@propietario_uno, @propietario_dos])
  		@tienda_dos = FactoryGirl.create(:tienda, propietarios: [@propietario_dos])
  		expect(Negocio.count).to be 2
  		expect(@propietario_uno.es_propietario?).to be true
  		expect(@propietario_uno.negocios_propios.empty?).to be false
  		expect(@propietario_dos.es_propietario?).to be true
  		expect(@propietario_dos.negocios_propios.empty?).to be false
  		@tienda.destroy
  		expect(Negocio.count).to be 1
  		expect(@propietario_uno.es_propietario?).to be false
  		expect(@propietario_uno.negocios_propios.empty?).to be true
  		expect(@propietario_dos.es_propietario?).to be true
  		expect(@propietario_dos.negocios_propios.empty?).to be false
  	end

  end
=end

end
