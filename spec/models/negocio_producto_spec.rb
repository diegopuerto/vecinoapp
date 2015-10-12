require 'rails_helper'

RSpec.describe NegocioProducto, type: :model do
  	
	describe "Atributos" do

		it "es válido con todos sus datos" do
	  		@negocio_producto = FactoryGirl.build(:negocio_producto)
			@negocio_producto.negocio = FactoryGirl.build(:tienda)
			@negocio_producto.producto = FactoryGirl.build(:jugo)
			expect(@negocio_producto).to be_valid
		end

		it "es inválido si falta algún dato" do
	  		@negocio_producto = FactoryGirl.build(:negocio_producto)
			@negocio_producto.valid?
			expect(@negocio_producto.errors[:negocio]).to include(I18n.t 'errors.messages.blank')
			expect(@negocio_producto.errors[:producto]).to include(I18n.t 'errors.messages.blank')
	  	end

	  	it "es inválido si el par negocio-producto no es único" do
	  		@negocio = FactoryGirl.build(:tienda)
	  		@producto = FactoryGirl.build(:jugo)
	  		@negocio_producto = FactoryGirl.create(:negocio_producto,
	  			negocio: @negocio,
	  			producto: @producto)
	  		@negocio_producto_no_valido = FactoryGirl.build(:negocio_producto,
	  			negocio: @negocio,
	  			producto: @producto)
	  		expect(@negocio_producto_no_valido).to be_invalid
	  		expect(@negocio_producto_no_valido.errors[:producto]).to include(I18n.t 'errors.messages.taken')
	  	end

	  	it "es inválido si el negocio o el producto no existen" do
	  		@negocio_producto = FactoryGirl.build(:negocio_producto)
	  		expect(Negocio.exists?(1)).to be false
	  		expect(Producto.exists?(1)).to be false
	  		@negocio_producto.negocio_id = 1
	  		@negocio_producto.producto_id = 1
	  		expect(@negocio_producto).to be_invalid
	  		expect(@negocio_producto.errors[:negocio]).to include(I18n.t 'errors.messages.blank')
	  		expect(@negocio_producto.errors[:producto]).to include(I18n.t 'errors.messages.blank')
	  	end
	end
end
