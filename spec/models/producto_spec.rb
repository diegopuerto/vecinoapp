require 'rails_helper'

RSpec.describe Producto, type: :model do
	it "es valido con todos sus datos" do 
		@producto = FactoryGirl.build(:producto)
		expect(@producto).to be_valid
	end
	
	describe "Atributos requeridos" do
			it "Es invalido sin nombre" do
			 	@producto = FactoryGirl.build(:producto, nombre: nil)
	  			#expect(@producto.valid?).to be false
	  			@producto.valid?
	  			expect(@producto.errors[:nombre]).to include(I18n.t 'errors.messages.blank')
		end
			it "es inválido sin marca" do
		  		@producto = FactoryGirl.build(:producto, marca: nil)
		  		@producto.valid?
		  		expect(@producto.errors[:marca]).to include(I18n.t 'errors.messages.blank')
		end

			it "es inválido sin presentacion" do
		  		@producto = FactoryGirl.build(:producto, presentacion: nil)
		  		@producto.valid?
		  		expect(@producto.errors[:presentacion]).to include(I18n.t 'errors.messages.blank')
		end

			it "es inválido sin imagen" do
		  		@producto = FactoryGirl.build(:producto, imagen: nil)
		  		@producto.valid?
		  		expect(@producto.errors[:imagen]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores de atributos" do

			it "es inválido si el nombre tiene más de 50 caracteres" do
  				@producto = FactoryGirl.build(:producto, nombre: "a"*51)
	  			@producto.valid?
	  			expect(@producto.errors[:nombre]).to include(I18n.t 'errors.messages.too_long', count: 50)
  		end


  			it "es inválido si el diferenciador tiene más de 50 caracteres" do
  				@producto = FactoryGirl.build(:producto, diferenciador: "a"*51)
	  			@producto.valid?
	  			expect(@producto.errors[:diferenciador]).to include(I18n.t 'errors.messages.too_long', count: 50)
  		end

  			it "es inválido si la marca tiene más de 50 caracteres" do
  				@producto = FactoryGirl.build(:producto, marca: "a"*51)
	  			@producto.valid?
	  			expect(@producto.errors[:marca]).to include(I18n.t 'errors.messages.too_long', count: 50)
  		end

  			it "es inválido si la presentacion tiene más de 50 caracteres" do
  				@producto = FactoryGirl.build(:producto, presentacion: "a"*51)
	  			@producto.valid?
	  			expect(@producto.errors[:presentacion]).to include(I18n.t 'errors.messages.too_long', count: 50)
  		end

  			it "es inválido si el precio tiene más de 50 caracteres" do
  				@producto = FactoryGirl.build(:producto, presentacion: "a"*51)
	  			@producto.valid?
	  			expect(@producto.errors[:presentacion]).to include(I18n.t 'errors.messages.too_long', count: 50)
  		end

  			it "es inválido si el precio es menor que cero" do
  				@producto = FactoryGirl.build(:producto, precio: -200)
	  			@producto.valid?
	  			expect(@producto.errors[:precio]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
	  	end

	  		it "es inválido si la imagen tiene más de 50 caracteres" do
  				@producto = FactoryGirl.build(:producto, imagen: "a"*51)
	  			@producto.valid?
	  			expect(@producto.errors[:imagen]).to include(I18n.t 'errors.messages.too_long', count: 50)
		end
	end


end


