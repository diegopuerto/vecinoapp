require 'rails_helper'

RSpec.describe Categoria, type: :model do
  it "es valido con todos sus datos" do 
		@categoria = FactoryGirl.build(:categoria)
		expect(@categoria).to be_valid
	end

	describe "Atributos requeridos" do
			it "Es invalido sin nombre" do
			 	@categoria = FactoryGirl.build(:categoria, nombre: nil)
	  			@categoria.valid?
	  			expect(@categoria.errors[:nombre]).to include(I18n.t 'errors.messages.blank')
			end

=begin
			it "es inválido sin imagen" do
		  		@categoria = FactoryGirl.build(:categoria, imagen: nil)
		  		@categoria.valid?
		  		expect(@categoria.errors[:imagen]).to include(I18n.t 'errors.messages.blank')
			end
=end

	end

	describe "Valores de atributos" do
			it "es inválido si el nombre tiene más de 100 caracteres" do
  				@categoria = FactoryGirl.build(:categoria, nombre: "a"*101)
	  			@categoria.valid?
	  			expect(@categoria.errors[:nombre]).to include(I18n.t 'errors.messages.too_long', count: 100)
  		end


  			it "es inválido si la imagen tiene más de 150 caracteres" do
  				@categoria = FactoryGirl.build(:categoria, imagen: "a"*151)
	  			@categoria.valid?
	  			expect(@categoria.errors[:imagen]).to include(I18n.t 'errors.messages.too_long', count: 150)
  		end
  	end
end
