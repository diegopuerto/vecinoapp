require 'rails_helper'

RSpec.describe Pedido, type: :model do
  it "Es valido con todos sus datos" do 
		@pedido = FactoryGirl.build(:pedido)
		expect(@pedido).to be_valid
	end

	describe "Atributos requeridos" do
			it "Es invalido sin total" do
			 	@pedido = FactoryGirl.build(:pedido, total: nil)
	  			@pedido.valid?
	  			expect(@pedido.errors[:total]).to include(I18n.t 'errors.messages.blank')
			end

			it "Es invalido sin estado" do
			 	@pedido = FactoryGirl.build(:pedido, estado: nil)
	  			@pedido.valid?
	  			expect(@pedido.errors[:estado]).to include(I18n.t 'errors.messages.blank')
			end

			it "Es invalido sin medio_pago" do
			 	@pedido = FactoryGirl.build(:pedido, medio_pago: nil)
	  			@pedido.valid?
	  			expect(@pedido.errors[:medio_pago]).to include(I18n.t 'errors.messages.blank')
			end
	end

	describe "Valores de atributos" do
			it "es inválido si el total es menor que cero" do
  				@pedido = FactoryGirl.build(:pedido, total: -200)
	  			@pedido.valid?
	  			expect(@pedido.errors[:total]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
  			end

  			it "es inválido si el comentario tiene más de 200 caracteres" do
  				@pedido = FactoryGirl.build(:pedido, comentario: "a"*201)
	  			@pedido.valid?
	  			expect(@pedido.errors[:comentario]).to include(I18n.t 'errors.messages.too_long', count: 200)
  			end

  			it "es inválido si la propina es menor que cero" do
  				@pedido = FactoryGirl.build(:pedido, propina: -2)
	  			@pedido.valid?
	  			expect(@pedido.errors[:propina]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
  			end

  	end

end
