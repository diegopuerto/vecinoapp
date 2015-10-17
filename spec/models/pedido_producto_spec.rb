require 'rails_helper'

RSpec.describe PedidoProducto, type: :model do
 
	describe "Atributos" do

		it "es válido con todos sus datos" do
	  		@pedido_producto = FactoryGirl.build(:pedido_producto)
			@pedido_producto.pedido = FactoryGirl.build(:pedido)
			@pedido_producto.producto = FactoryGirl.build(:jugo)
			expect(@pedido_producto).to be_valid
		end

		it "es inválido si falta algún dato" do
	  		@pedido_producto = FactoryGirl.build(:pedido_producto)
			@pedido_producto.valid?
			expect(@pedido_producto.errors[:pedido]).to include(I18n.t 'errors.messages.blank')
			expect(@pedido_producto.errors[:producto]).to include(I18n.t 'errors.messages.blank')
	  	end 

	  	it "es inválido si el par pedido-producto no es único" do
	  		@pedido = FactoryGirl.build(:pedido)
	  		@producto = FactoryGirl.build(:jugo)
	  		@pedido_producto = FactoryGirl.create(:pedido_producto,
	  			pedido: @pedido,
	  			producto: @producto)
	  		@pedido_producto_no_valido = FactoryGirl.build(:pedido_producto,
	  			pedido: @pedido, 
	  			producto: @producto)
	  		expect(@pedido_producto_no_valido).to be_invalid
	  		expect(@pedido_producto_no_valido.errors[:producto]).to include(I18n.t 'errors.messages.taken')
	  	end

	  	it "es inválido si el pedido o el producto no existen" do
	  		@pedido_producto = FactoryGirl.build(:pedido_producto)
	  		expect(Pedido.exists?(1)).to be false
	  		expect(Producto.exists?(1)).to be false
	  		@pedido_producto.pedido_id = 1
	  		@pedido_producto.producto_id = 1
	  		expect(@pedido_producto).to be_invalid
	  		expect(@pedido_producto.errors[:pedido]).to include(I18n.t 'errors.messages.blank')
	  		expect(@pedido_producto.errors[:producto]).to include(I18n.t 'errors.messages.blank')
	  	end

		it "Es invalido sin cantidad" do
			 @pedido_producto = FactoryGirl.build(:pedido_producto, cantidad: nil)
	  		 @pedido_producto.valid?
	  		 expect(@pedido_producto.errors[:cantidad]).to include(I18n.t 'errors.messages.blank')
		end

		it "Es invalido sin precio" do
			 @pedido_producto = FactoryGirl.build(:pedido_producto, precio: nil)
	  		 @pedido_producto.valid?
	  		 expect(@pedido_producto.errors[:precio]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores de atributos" do
		it "es inválido si la cantidad es menor que cero" do
  				@pedido_producto = FactoryGirl.build(:pedido_producto, cantidad: -200)
	  			@pedido_producto.valid?
	  			expect(@pedido_producto.errors[:cantidad]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
	  	end

	  	it "es inválido si el precio es menor que cero" do
  				@pedido_producto = FactoryGirl.build(:pedido_producto, precio: -200)
	  			@pedido_producto.valid?
	  			expect(@pedido_producto.errors[:precio]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
	  	end
	end

end